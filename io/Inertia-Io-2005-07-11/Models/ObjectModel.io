//
// ObjectModel.io
//

//
// FolderModel.io
//

/*
xFolderItem := Object clone do (
  name := Nil
  type := Nil
  fields := Nil
)
*/

List asString := method (
  buffer := Buffer clone
  self foreach( i,
    item, buffer append( item )
    if( i < self count - 1, buffer append( ", " ) )
  )
  buffer asString
)
getSlot("Block") asString := method( code )
Object asString := method( uniqueId asString )

ObjectModel := Object clone do (

  init := method (
    self object := Nil
    self columns := list (
      Object clone do ( name := "Value"; type := "String"; width := 60; format := "%s" )
      //Object clone do ( name := "Type"; type := "String"; width := 60; format := "%s" )
    )
    self cache := Nil
  )

  items := method (
    if( cache, return cache )

    self cache = object slotNames map ( i, item,
      fsitem := FolderItem clone
      fsitem name = item
      fsitem type = object getSlot(item) type
      fsitem fields = list( object getSlot(item) )
      fsitem
    )

    return cache
  )

)

PropertyModel := Object clone do (

  init := method (
    self object := Nil
    self columns := list (
      Object clone do ( name := "Value"; type := "String"; width := 60; format := "%s" )
      //Object clone do ( name := "Type"; type := "String"; width := 60; format := "%s" )
    )
    self cache := Nil
  )

  sortOrder := list( "caption", "left", "top", "width", "height", "reshape" )

  items := method (
    if( cache, return cache )

    //self cache = object slotNames map ( i, item,
    self cache = list()
    object slotNames foreach ( i, item,
      //if( object getSlot(item) type != "Attr", continue )
      fsitem := FolderItem clone
      fsitem name = item
      fsitem type = object getSlot(item) type
      fsitem fields = list( "" )
      if( object getSlot(item) type == "Attr" ) then (
        fsitem fields = list( object getSlot(item) get() )
        cache add( fsitem )
      )

      //fsitem
    )

    cache sortBy( block( a, b, sortOrder indexOf(a name) < sortOrder indexOf(b name) ) )

    return cache
  )

)

