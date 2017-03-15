//
// ContactModel.io
//

Inertia do (

Contact := Object clone do (

  age  := Nil

)

ContactModel := Model clone do (

  init := method (
    self contacts := Map clone do (
      atPut( "Mike", Contact clone do ( age = 31 ) )
      atPut( "Joe", Contact clone do ( age = 45 ) )
    )
    self columns := list (
      Object clone do ( name := "Age"; type := "Number"; width := 60; format := "%d" )
    )
    self cache := Nil
  )

  items := method (
    if( cache, return cache )

    //self cache = contacts map ( name, item,
    self cache = List clone
    contacts foreach ( name, item,
      fsitem := FolderItem clone
      fsitem name = name
      fsitem type = "Contact"
      fsitem fields = list( item age )
      cache add( fsitem )
    )

    return cache
  )

  addContact := method ( sender, form,
    contacts atPut( form at(0), form at(1) )
    self cache = Nil
  )

)

)

