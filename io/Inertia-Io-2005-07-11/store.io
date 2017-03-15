DataStore := Object do (

  db := Nil

  open := method ( path,
    self db = SQLite clone open( path )
  )

  insert := method ( object,
    Nil
  )

)

db := SQLite clone open( "Mail.db" )

db tableNames foreach( name,
  writeln( name )
  writeln( "---------------" )
  writeln( db columnNamesOfTable( name ) )
)
writeln( "" )

if( db tableNames contains( "Folders" ) == Nil ) then (
  db exec( "create table Folders (ID INTEGER primary key, Name TEXT, Parent INTEGER)" )
)
if( db tableNames contains( "Messages" ) == Nil ) then (
  db exec( "create table Messages (ID INTEGER primary key, Subject TEXT, Received DOUBLE, Body TEXT)" )
)

sql := "insert into Messages values (" asBuffer
sql append( "NULL" )
sql append( ", " .. "'Subject'" )
sql append( ", " .. Date clone now asString( "%Y%m%d.%H%M%S" ) asNumber )
sql append( ", " .. "'" .. db escapeString( "This\nis\nthe\nbody" ) .. "'" )
sql append( ")" )

db exec( sql asString )

msgs := db exec( "select * from Messages" )

msgs foreach( item,
  writeln( item at("ID"), " ", item at("Subject"), " ", item at("Received"), "\n", item at("Body") )
)

// -------------------------------------------------------------------------- //

if( db tableNames contains( "Interface" ) == Nil ) then (
  db exec( "create table Interface (ID INTEGER primary key, Parent INTEGER, Name TEXT, Value)" )
)

db exec( "insert into Interface values (NULL, 0, 'button', 'Button')" )
id := db lastInsertRowId
db exec( "insert into Interface values (NULL, " .. id .. ", 'caption', 'Click Me')" )
db exec( "insert into Interface values (NULL, " .. id .. ", 'left', 10)" )

msgs := db exec( "select * from Interface" )

msgs foreach( item,
  writeln( item at("ID"), "\r\t", item at("Parent"), "\r\t\t", item at("Name"), "\r\t\t\t\t", item at("Value") )
)

db close

