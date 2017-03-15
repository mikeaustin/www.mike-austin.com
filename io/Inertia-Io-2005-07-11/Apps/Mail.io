//
// Mail.io
//

MailFolderModel := Object clone setProto( Model ) do (

  init := method (
    self contacts := Map clone do (
      atPut( "Inbox", Object clone )
      atPut( "Outbox", Object clone )
    )
    self columns := list (
      Object clone do ( name := "#"; type := "Number"; width := 30; format := "%d" )
    )
    self cache := Nil
  )

  items := method (
    if( cache, return cache )

    //self cache = contacts map ( name, item,
    self cache = List clone
    contacts foreach ( name, item,
      fsitem := Object clone
      fsitem name := name
      fsitem type := "Folder"
      fsitem fields := list( 123 )
      cache add( fsitem )
      fsitem
    )

    return cache
  )

)

MailMessagesModel := Object clone setProto( Model ) do (

  init := method (
    self contacts := Map clone do (
      atPut( "Test", Object clone )
      atPut( "Test 2", Object clone )
    )
    self columns := list (
      Object clone do ( name := "From"; type := "String"; width := 120; format := "%s" ),
      Object clone do ( name := "Received"; type := "Date"; width := 70; format := "%y-%m-%d" ),
      Object clone do ( name := "Size"; type := "Number"; width := 40; format := "%d" )
    )
    self cache := Nil
  )

  items := method (
    if( cache, return cache )

    //self cache = contacts map ( name, item,
    self cache = List clone
    contacts foreach ( name, item,
      fsitem := Object clone
      fsitem name := name
      fsitem type := "Folder"
      fsitem fields := list( "Nobody", Date clone, 10 )
      cache add( fsitem )
      fsitem
    )

    return cache
  )

)

MessageWindow := Object clone setProto( Window ) do (
  Nil
)

Mail := Object clone setProto( Window ) do (

  init := method (
    resend()
    caption = "Mail"
    addChild( self menuBar := MenuBar clone )
    menuBar do (
      drawBorder := Nil
      addItem( MenuButton clone do (
        caption = "Message"
        subMenu = MenuPane clone do (
          addItem( MenuItem clone do ( caption = "New Message" ) )
        )
      ))
      addItem( MenuButton clone do ( caption = "View" ) )
    )
    /*
    addChild( folders := Table clone do (
      left = 5; top = 21; width = 200; height = 254
      reshape = list( Reshape None, Reshape Size )
      model = MailFolderModel clone
    ))
    */
    addChild( messages := Table clone do (
      left = 210; top = 21; width = 185; height = 200
      reshape = list( Reshape Size, Reshape None )
      //model = MailMessagesModel clone
      model = StoreModel clone open( "Inbox.db" )
      contact := Object clone do (
        name := Object clone do ( type = "attr"; _value := "Mike" )
        phone := Object clone do ( type = "attr"; _value := "650 555 1212" )
        address := Object clone do ( type = "attr"; _value := "123 Loop Way" )
      )
      model store( contact )
    ))
    
    width = 800; height = 600; sizeChanged = 1 // Fix
  )
  
)

