//
// StoreModel
//

Inertia do (

StoreModel := Object clone do (

  db := Nil

  typeTable := Map clone do (
    atPut( "String", "TEXT" )
    atPut( "Number", "INTEGER" )
    atPut( "Date", "DATE" )
  )

  open := method ( path,
    self db = SQLite3 clone open( path )

    if( db tableNames contains( "Data" ) == Nil ) then (
      //db exec( "create table Data (ID INTEGER primary key, name TEXT, phone TEXT, address TEXT)" )
      db exec( "create table Data (ID INTEGER primary key, name TEXT)" )
    )
    
    self
  )

  columns := method (
    cols := list()
    
    db columnNamesOfTable( "Data" ) foreach( name,
      if( name == "ID", continue )
      col := Object clone
      col name := name
      col type := "String"
      col width := 100
      col format := "%s"
      cols add( col )
      writeln( name )
    )
    
    cols
  )

  items := method (
    db exec( "select * from Data" )
  )

  select := method ( statement, firstRecord, numRecords,
    sql := "select * from Data where " .. statement
    if( firstRecord ) then (
      sql = sql .. "limit " .. firstRecord .. ", " .. numRecords
    )
    db exec( sql )
  )
  
  store := method ( object,
    fields := list()

    object slotNames foreach( slotName,
      if( object getSlot(slotName) type == "attr" ) then (
        fields add( list( slotName,
                          object getSlot(slotName) _value,
                          typeTable at(object getSlot(slotName) _value type) ) )
      )
    )

    fields foreach( field,
      if( db columnNamesOfTable( "Data" ) contains( field at(0) ) == Nil ) then (
        sql := "alter table Data add column " .. field at(0) .. " " .. field at(2)
        writeln( sql )
        db exec( sql )
      )
    )

    sql := "insert into Data (" asBuffer
    
    fields foreach( i, field,
      sql append( field at(0) )
      if( i < fields count - 1, sql append( ", " ) )
      //writeln( i, " ", fields count )
    )
    
    sql append( ") values (" )
    fields foreach( i, field,
      sql append( "'" .. field at(1) .. "'" )
      if( i < fields count - 1, sql append( ", " ) )
    )
    sql append( ")" )
    
    //writeln( sql )
    db exec( sql asString )
  )

)

Contact := Object clone do (

  init := method (
    self name := Object clone do ( type = "attr"; _value := "Mike" )
    self age := Object clone do ( type = "attr"; _value := 31 )
    self phone := Object clone do ( type = "attr"; _value := "650 555 1212" )
    self address := Object clone do ( type = "attr"; _value := "123 Loop Way" )
    self fax := Object clone do ( type = "attr"; _value := "650 555 2121" )
  )

)

)

/*
ds := DataStore clone open( "Test.db" )
ds store( Contact clone )

data := ds select( "phone like '%650%'" )
data foreach( item,
  ds columns foreach( column,
    write( item at(column), " | " )
  )
  writeln( "" )
)
*/

