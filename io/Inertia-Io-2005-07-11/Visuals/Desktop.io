//
// Desktop.io
//

writeln( "[Desktop.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  Desktop := Object clone setProto( Visual ) do (

    type := "Desktop"

    focusedWindow := Nil
    grabbedVisual := Nil
    enteredVisual := Nil

    lastPosition := 40

    init := method (
      writeln( "> Desktop:init()" )
      resend()
      self focusedWindow := Window clone

      prop := MenuItem clone do ( caption = "Properties..." )
      switch := MenuItem clone do ( caption = "Switch Desktop" )
      self contextMenu := MenuPane clone
      contextMenu addItem( MenuItem clone do (
        caption = "Refresh"
        subMenu = MenuPane clone do (
          addItem( MenuItem clone do ( caption = "Submenu 1" ) )
          addItem( MenuItem clone do ( caption = "Submenu 2" ) )
        )
      ))

      contextMenu addItem( prop )
      contextMenu addItem( switch )
      self actionPerformed := method ( Inertia desktop addChild( Calculator clone ) )
      prop target = self
      switch xaction = list( self, "switchDesktop" )

      self background := Image clone open( launchPath appendPath( "Nova_by_yoyin.jpg" ) )
      //self background := Image clone open( launchPath appendPath( "Lamas_by_Y2M.jpg" ) )

      self enteredVisual = self
      writeln( "< Desktop:init()" )
    )

    switchDesktop := method (
      if( Inertia desktop == Inertia screen at(0) ) then (
        Inertia desktop = Inertia screen at(1)
      ) else (
        Inertia desktop = Inertia screen at(0)
      )
    )

    drawVisual := method (
      subnodes foreach( node,
        node updateTexture()
      )
      
      background bindTexture()
      glEnable( GL_TEXTURE_2D )
      //background draw()
      Graphics begin( GL_QUADS,
        Graphics texCoord( 0.0, .75 ); Graphics vertex(     0,   0 )
        Graphics texCoord( 1.0, .75 ); Graphics vertex( width,   0 )
        Graphics texCoord( 1.0, 0.0 ); Graphics vertex( width, 768 )
        Graphics texCoord( 0.0, 0.0 ); Graphics vertex(     0, 768 )
      )
      glDisable( GL_TEXTURE_2D )
    )

    sendEvent := method ( event,
      if( event type == "mouseDown" ) then (
        self grabbedVisual := resend()
      ) elseif( event type == "mouseUp" ) then (
        grabbedVisual Visual:sendEvent( MouseEvent:( "mouseUp", event button, event x - grabbedVisual screenLeft, event y - grabbedVisual screenTop, event modifiers ) )
        self grabbedVisual = Nil
      ) elseif( event type == "mouseMove" ) then (
        if( grabbedVisual ) then (
          grabbedVisual Visual:sendEvent( MouseEvent:( "mouseMove", event button, event x - grabbedVisual screenLeft, event y - grabbedVisual screenTop, event modifiers ) )
        ) else (      
          visual := resend()
          if( visual != enteredVisual ) then (
            enteredVisual sendEvent( MouseEvent:( "mouseExit", event button, event x - enteredVisual screenLeft, event y - enteredVisual screenTop ) )
            self enteredVisual = visual
            visual sendEvent( MouseEvent:( "mouseEnter", event button, event x - enteredVisual screenLeft, event y - enteredVisual screenTop ) )
          )
        )
      ) elseif( event type == "keyDown" ) then (
        focusedWindow sendEvent( event )
      )
    )
    
    mouseDown := method ( event,
      if( event button == 2 ) then (
        contextMenu left = event x - 1
        contextMenu top = event y - 1
        _addChild( contextMenu )
      )
    )

    _addChild := getSlot("addChild")
  
    addChild := method( visual,
      self focusedWindow isFocused = Nil
      self focusedWindow = visual

      visual isFocused = 1
      if( (visual left == -1) and (visual top == -1) ) then (
        visual left = lastPosition
        visual top  = lastPosition
        lastPosition = lastPosition + 20
      )
      _addChild( visual )

      visual invalidate()
    )

  )

)

