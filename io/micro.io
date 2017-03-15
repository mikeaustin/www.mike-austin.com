#
# micro.io 0.1 - 2005 Mike Austin
# An Io to GNU Lightning compiler written in Io
#

# NOTES:

# There are 6 registers available in GNU Lightning.  Only D0 is used as a
# destination for computing - the rest are to be used for arguments and
# locals.  Arguments and locals are stored into registers by thier index number
# within the argNames list.
#
# Each message that is found is looked up in messageTable, and if found, the
# corresponding method is called to emit the instructions.  If a message is not
# found in messageTable, it then looks in the argNames list.  If a message is
# found, the value of it's corresponding register is copied into D0.

# BUGS:

# - When using multiple while loops, the result of a computation is not correct.
#   It's very close, but not correct - so I assume it is a problem of the last
#   computation in the loop not getting run or overwriting D0

# - Compiler Methods --------------------------------------------------------- #

# The messageTable is used to look up builtin messages, such as setSlot,
# updateSlot, while, *, +, etc.  Each method emits instructions pertaining to
# the message.  The result of any computation must be stored in D0.

Message messageTable := Map clone do (
  # <var> ":=" <number>
  atPut( "setSlot", method( m, argNames,
    writeln( "<declare>  movi ", argAt(0) name strip("\""), ", ", argAt(1) name asNumber )
    # Append the new slotname to the arguments/locals list
    argNames add( argAt(0) name strip("\"") )
    # Copy the literal number to it's register index
    m movi( -1002 - argNames indexOf( argAt(0) name strip("\"") ), argAt(1) name asNumber )
  ))
  
  # <var> "=" <expression>
  atPut( "updateSlot", method( m, argNames,
    # Compile the rhs expression
    argAt(1) ?compile( m, argNames )
    writeln( "<store>    movr ", argAt(0) name strip("\""), ", R0" )
    # Then store it in the lhs variable
    m movr( -1002 - argNames indexOf( argAt(0) name strip("\"") ), m R0 )
  ))

  # <var> "*" <var>
  atPut( "*", method( m, argNames,
    writeln( "<multiply> mulr R0, ", argAt(0) name strip("\"") )
    # Multiply R0 by the variable argument of *()
    m mulr( m R0, -1002 - argNames indexOf( argAt(0) name strip("\"") ) )
    # Compile the next message in the chain
    attachedMessage ?compile( m, argNames )
  ))

  # <var> "+" <number> | <var>
  atPut( "+", method( m, argNames,
    if( argAt(0) name asNumber,
      writeln( "<add>      addi R0, ", argAt(0) name asNumber )
      # Add R0 by the literal argument of +()
      m addi( m R0, argAt(0) name asNumber )
    ) else (
      writeln( "<add>      addr R0, ", argAt(0) name strip("\"") )
      # Add R0 by the variable argument of +()
      m addr( m R0, -1002 - argNames indexOf( argAt(0) name strip("\"") ) )
    )
    # Compile the next message in the chain
    attachedMessage ?compile( m, argNames )
  ))
  
  # <var> "-" <number> | <var>
  atPut( "-", method( m, argNames,
    if( argAt(0) name asNumber,
      writeln( "<subtract> subi R0, ", argAt(0) name asNumber )
      # Subtract R0 by the literal argument of -()
      m subi( m R0, argAt(0) name asNumber )
    ) else (
      writeln( "<subtract> subr R0, " argAt(0) name strip("\"") )
      # Subtract R0 by the variable argument of -()
      m subr( m R0, -1002 - argNames indexOf( argAt(0) name strip("\"") ) )
    )
    # Compile the next message in the chain
    attachedMessage ?compile( m, argNames )
  ))
  
  # <var> ">" <number>
  atPut( ">", method( m, argNames,
    writeln( "<greater>  gti  R0, ", argAt(0) name asNumber )
    # Test if R0 is greater than the literal argument of >
    # NOTE: gti does not work for me, using subtraction trick
    #m gti( m R0, argAt(0) name asNumber )
    m subi( m R0, argAt(0) name asNumber )
  ))
  
  # <var> "<" <number>
  atPut( "<", method( m, argNames,
    writeln( "<lessthan> lti R0, ", -argAt(0) name asNumber )
    # Test if R0 is less than the literal argument of <
    # NOTE: gti does not work for me, using subtraction trick
    #m gti( m R0, argAt(0) name asNumber )
    m subr( m R0, -argAt(0) name asNumber )
  ))
  
  # "while(" <condition>"," <message> ")"
  atPut( "while", method( m, argNames,
    condition := argAt(0)
    smessage  := argAt(1)
    loop := m get_label
      # Process all the lines in a block
      while( smessage,
        smessage ?compile( m, argNames )
        smessage = smessage nextMessage
      )
      # Compile the condition so we can test it
      condition ?compile( m, argNames )
      writeln( "<brnchgte> bgei R0, 1" )
      # Test the condition and loop if true
      m bgei( loop, m R0, 1 )
  ))
  
  # "return" <var>
  atPut( "return", method( m, argNames,
    writeln( "in return" )
    # Compile the rhs expression
    argAt(0) ?compile( m, argNames )
  ))
)

# The Message compile() method uses the messageTable and the argNames list to
# compile the target message.

Message compile := method( m, argNames,
  if( messageTable hasKey(name) ) then (
    emitter := messageTable at(name)
    emitter( m, argNames )
  ) elseif( argNames contains( name ) ) then (
    writeln( "<load>     movr R0, ", name )
    # Copy the variable into R0
    m movr( m R0, -1002 - argNames indexOf( name ) )
    # Compile the next message in the chain
    attachedMessage ?compile( m, argNames )
  ) else (
    writeln( "Compilatin of ", name, " is not yet supported." )
  )
)

# The Block compile() message is the highest level method for compiling.  It
# traverses the block tree structure, calling compile() on each nextMessage.

getSlot("Block") compile := method (
  writeln( "Block:compile" )
  argNames := getSlot("self") argumentNames
  smessage := getSlot("self") message

  m := MicroFunction clone
  m begin( argNames count )
    # Copy each argument into its own register
    argNames foreach( i, name,
      if( i > 5, break )
      m getarg( -1002 - i, m arg() )
    )

    # Process all the lines in a block
    while( smessage,
      smessage ?compile( m, argNames )
      smessage = smessage nextMessage
    )

    # Copy the last computation into the return register
    m movr( m RET, m R0 )

    m ret
  m end

  return m
)

# - Compiler Tests ----------------------------------------------------------- #

factorial := method ( n,
  a := 1
  while( n > 1,
    a = a * n
    n = n - 1
  )
  return a
) compile

writeln( factorial call( 5 ) )

test := method ( i, j,
  a := 0
  while( i > 0,
    while( j > 0,
      a = i * j + a
      j = j - 1
    )
    i = i - 1
  )
  a
)

testc := getSlot("test") compile

writeln( test( 10, 100 ) )
writeln( testc call( 10, 100 ) )

