//
// FolderModel.io
//

Number _asString := Number getSlot("asString")
Number asString := method ( format,
  string := _asString()
  //" " * (15 - string length) .. string
)

FolderItem := Object clone do (
  name := Nil
  type := Nil
  fields := Nil
)

FolderModel := Object clone do (

  init := method (
    self path := "."
    self columns := list (
      Object clone do ( name := "Size"; type := "Number"; width := 60; format := "%d" ),
      Object clone do ( name := "Type"; type := "String"; width := 60; format := "%s" ),
      Object clone do ( name := "Last Modified"; type := "Date"; width := 60; format := "%Y-%m-%d" )
    )
    self cache := Nil
  )

  items := method (
    if( cache, return cache )
    
    folder := Directory clone setPath( path )
    
    self cache = folder items select( i, item, item type == "File" ) map ( i, item,
      fsitem := FolderItem clone
      fsitem name = item name
      fsitem type = item type
      if( item type == "Directory" ) then (
        fsitem fields = list( item count, "Folder", Date )
      ) else (
        fsitem fields = list( item size, "File", item lastDataChangeDate )
      )
      fsitem
    )

    return cache
  )

)

/*
fs := FolderModel clone
write( "Name\r\t\t" )
fs columns foreach( i, column,
  write( "\t", column name )
)
writeln( "" )
fs items foreach( item,
  write( item name, "\r\t\t" )
  item fields foreach( i, field,
    write( "\t", field asString( fs columns at(i) format ) )
  )
  writeln( "" )
)
*/

