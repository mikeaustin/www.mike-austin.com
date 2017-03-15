//
// Calculator.io
//

writeln( "[Calculator.io]" )

// -------------------------------------------------------------------------- //

Calculator := Window clone do (

  enterState := Nil
  lastOper := "+"

  init := method (
    resend()
    
    caption = "Calculator"
    
    addChild( self field := TextField clone setModel( NumberModel clone ) do (
      label align = Align Right
      left = 5; top = 5; width = 130
    ))

    _x := 0; _y := 0
    x := method ( _x = _x + 35; _x - 35 )
    y := method ( _y )

    _x = 5; _y = 35
    addButton( "C",  x, y ); addButton( "/", x, y ); addButton( "*", x, y ); addButton( "-", x, y )
    _x = 5; _y = 65
    addButton( "7",  x, y ); addButton( "8", x, y ); addButton( "9", x, y ); addButton( "+", x, y ) height = 50
    _x = 5; _y = 95
    addButton( "4",  x, y ); addButton( "5", x, y ); addButton( "6", x, y )
    _x = 5; _y = 125
    addButton( "1",  x, y ); addButton( "2", x, y ); addButton( "3", x, y ); addButton( "=", x, y ) height = 50
    _x = 5; _y = 155
    addButton( "0",  x, y ) width = 60; x; addButton( ".", x, y )

    width = 140; height = 200
  )

  addButton := method ( caption, left, top,
    button := Button clone
    button caption = caption
    button left = left; button top = top
    button width = 25; button height = 20
    button xxaction = Action:( self, "buttonPressed", button )
    addChild( button )
    button
  )

  keyDown := method ( event,
    handleInput( event key asCharacter )
  )
  
  buttonPressed := method ( sender, button,
    handleInput( button caption )
  )
  
  handleInput := method ( character,
    if( enterState == Nil ) then (
      field buffer empty()
      self enterState = 1
    )
    if( character == "*" ) then (
      field model value = field model value perform( lastOper, field buffer asNumber )
      self enterState = Nil
      lastOper = "*"
    ) elseif( character at(0) isDigit ) then (
      field buffer append( character )
    )
  )
  
)

