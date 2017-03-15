//
// InertiaIRC.io
//

doFile( "Clients/IRC.io" )

writeln( "[InertiaIRC.io]" )

// -------------------------------------------------------------------------- //

Nil asString := "<nil>"

//InertiaIRC := Window clone do (
InertiaIRC := Object clone setProto( Window ) do (

  init := method (
    resend()
    
    titleBar title text = "Inertia IRC"
    
    addChild( self history := TextEdit clone do (
      left = 5; top = 5; width = 290; height = 225
      reshape = list( Reshape Size, Reshape Size )
    ))

    addChild( self textField := TextField clone do (
      left = 5; top = 235; width = 210
      reshape = list( Reshape Size, Reshape Move )
    ))

    addChild( self userListScroller := Visual clone do (
      left = 300; top = 5; width = 95; height = 250
      reshape = list( Reshape Move, Reshape Size )
    ))

    addChild( sendButton := Button clone do (
      caption = "Send"
      left = 220; top = 235; width = 75; height = 20
      reshape = list( Reshape Move, Reshape Move )
    ))
    sendButton xaction = list( self, "connectToServer" )
    
    addChild( Label clone do (
      text = "Status: Disconnected"
      left = 5; top = 258; width = 390; height = 20
      reshape = list( Reshape Size, Reshape Move )
    ))
    
    textField enterDown := block ( event,
      if( textField buffer length > 0 ) then (
        try (
          irc socket write( "PRIVMSG " .. irc channel .. " :" .. textField buffer asString .. "\r\n" )
        )
        history append( "MikeAustin" .. "> " .. textField buffer asString .. "\n" )
        history scrollToLastPage()
        textField buffer empty()
      )
    )

    self irc := IRCClient clone do ( channel = "#test" )
    irc xtarget = list( self, "readData" )
    
    self focusedVisual = textField
    
    //history append( File clone openForReading( "test.io" ) asString )
  )

  connectToServer := method (
    irc @@connect
  )

  readData := method ( data,
    if( data find( "PRIVMSG" ) ) then (
      writeln( "[", data, "]" )
      user := data fromTo( 1, data find( "!" ) ) asString
      msg := data after( irc channel .. " :" ) asString
      history append( user .. "> " .. msg )
    ) else (
      history append( data )
    )
  )

)

