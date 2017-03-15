//
// Window.io
//

writeln( "[Window.io]" )

// -------------------------------------------------------------------------- //

OpenGL GL_TEXTURE_RECTANGLE_EXT := 0x84F5

Inertia do (

  //
  // A Window is a movable, dragable visual with a titlebar
  //

  //Window := Visual clone do (
  Window := Object clone setProto( Visual ) clone do (

    type := "Window"

    // Get Visual's addChild so we don't recurse

    _addChild := getSlot("addChild")

    isFocused     := Nil
    focusedVisual := Nil
    sizeChanged   := Nil
    invalidated   := 1
    isPopup       := Nil
    minWidth      := 100
    minHeight     := 20
    scale := 1

    // Set up a large texture to use while resizing windows
    
    textures := List clone
    glGenTextures( 1, textures )
    largeTexId := textures at(0)

    glBindTexture( GL_TEXTURE_RECTANGLE_EXT, largeTexId )
    glTexImage2D( GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, 1024, 768, 0, GL_RGBA, GL_UNSIGNED_BYTE, Nil )

    //
    // Add the basic visuals and set up a texture for the window
    //

    init := method (
      resend()
      left = -1; top = -1; width = 400; height = 300
    
      self caption := attr( "Untitled" ) do (
        set := method ( value, context titleBar title text = value; _value:( value ) )
      )
    
      _addChild( self clientArea := ClientArea clone )
      _addChild( self titleBar := TitleBar clone do ( extent do ( x = 400; y = 20 ) ) )
      _addChild( self sizer := Sizer clone do ( left = 380; top = 280; width = 20; height = 20 ) )

      textures := List clone
      glGenTextures( 1, textures )
      self textureId := textures at(0)

      glBindTexture( GL_TEXTURE_RECTANGLE_EXT, textureId )
      ////glCopyTexImage2D( GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, 0, 768 - height, width, height, 0 )
      glTexImage2D( GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Nil )
    )

    //
    // Capture mouse clicks to push window to front
    //

    sendEvent := method ( event,
      if( event type == "mouseDown",
        parent := parent
        parent subnodes remove( self )
        parent subnodes add( self )

        Inertia desktop focusedWindow isFocused = Nil
        Inertia desktop focusedWindow invalidate()
        if( Inertia desktop focusedWindow isPopup and Inertia desktop focusedWindow != self ) then (
          Inertia desktop focusedWindow parent subnodes remove( Inertia desktop focusedWindow )
        )

        Inertia desktop focusedWindow = self
        self isFocused = 1
      )
      resend()
    )

    //
    // The contents of the window have changed, so update the texture
    //

    invalidate := method (
      //writeln( "Window:invalidate()" )
      self invalidated = 1
      glutPostRedisplay()
    )
    
    updateTexture := method (
      if( invalidated == Nil, return )

      //writeln( "Window:updateTexture()" )
      glLoadIdentity()
      SceneNode:display()
      glReadBuffer( GL_BACK )
      glBindTexture( GL_TEXTURE_RECTANGLE_EXT, textureId )
      if( sizeChanged ) then (
        writeln( "updateTexture() - New texture" )
        glCopyTexImage2D( GL_TEXTURE_RECTANGLE_EXT, 0, GL_RGBA, 0, 768 - height, width, height, 0 )
        self sizeChanged = Nil
      ) else (
        //writeln( "updateTexture() - Same texture" )
        glCopyTexSubImage2D( GL_TEXTURE_RECTANGLE_EXT, 0, 0, 0, 0, 768 - height, width, height )
      )
      self invalidated = Nil
    )

    XdrawVisual := method (
      Graphics stack (
        glTranslated( (width / 2) - ((width / 2) * scale), (height / 2) - ((height / 2) * scale), 0 )
        glScaled( scale, scale, 0 )
        resend()
      )
    )

    //
    // Draw the textured window
    //
    
    drawVisual := method (
      glEnable( GL_TEXTURE_RECTANGLE_EXT )
      glBindTexture( GL_TEXTURE_RECTANGLE_EXT, textureId )
      Graphics color( 1, 1, 1, .95 )
      Graphics begin( GL_QUADS,
        Graphics texCoord(     0, height ); Graphics vertex(     0,      0 )
        Graphics texCoord( width, height ); Graphics vertex( width,      0 )
        Graphics texCoord( width,      0 ); Graphics vertex( width, height )
        Graphics texCoord(     0,      0 ); Graphics vertex(     0, height )
      )
      glDisable( GL_TEXTURE_RECTANGLE_EXT )
    )

    drawShadow := method (
      borderSize := 5
      borderColor := 0.5
      borderAlpha := 0.25
      Graphics begin( GL_QUAD_STRIP,
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( width, borderSize + 0 ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( width, borderSize + 0 - borderSize );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( width, borderSize + 0 ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( width + borderSize * 0.7, borderSize + 0 - borderSize * 0.7 );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( width, borderSize + 0 ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( width + borderSize, borderSize + 0 );
        
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( width, height ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( width + borderSize, borderSize / 2 + height );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( width, height ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( width + borderSize * 0.7, borderSize / 2 + height + borderSize * 0.7 );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( width, height ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( width, borderSize / 2 + height + borderSize );

        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( 0, height ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( 0, borderSize / 2 + height + borderSize );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( 0, height ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( 0 - borderSize * 0.7, borderSize / 2 + height + borderSize * 0.7 );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( 0, height ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( 0 - borderSize, borderSize / 2 + height );

        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( 0, borderSize + 0 ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( 0 - borderSize, borderSize + 0 );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( 0, borderSize + 0 ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( 0 - borderSize * 0.7, borderSize + 0 - borderSize * 0.7 );
        Graphics color( 0, 0, 0, borderAlpha ); Graphics vertex( 0, borderSize + 0 ); Graphics color( 0, 0, 0, 0 ); Graphics vertex( 0, borderSize + 0 - borderSize );
      )
    )

    // Don't need do draw any children since window is textured

    display := Nil

    Xdisplay := method (
      Nil
      //glPushMatrix()
      //  glTranslated( width / 2, height / 2, 0 )
      //  glRotated( (scale - 1) * 380, 0, 0, 1 )
      //  glTranslated( -width / 2, -height / 2, 0 )
      //  glTranslated( (width / 2) - ((width / 2) * scale), (height / 2) - ((height / 2) * scale), 0 )
      //  glScaled( scale, scale, 0 )
      //  resend()
      //glPopMatrix()
    )

    //
    // Draw a blue border around active windows
    //
    
    drawBorder := method (
      /*
      glTranslated( width / 2, height / 2, 0 )
      glRotated( (scale - 1) * 380, 0, 0, 1 )
      glTranslated( -width / 2, -height / 2, 0 )
      glTranslated( (width / 2) - ((width / 2) * scale), (height / 2) - ((height / 2) * scale), 0 )
      glScaled( scale, scale, 0 )
      */
      glLineWidth( 1.5 )
      if( isFocused, Graphics color( 0.65, 0.8, 0.95 ), Graphics color( 0.8, 0.8, 0.8 ) )
      //Graphics drawLineRect( 0, 0, width, height )
      Graphics drawLineRect( 0 - 1, 0 - 1, width + 2, height + 2 )
      glLineWidth( 1 )
    )

    //
    // New children get sent to the clientArea
    //
    
    addChild := method ( visual,
      clientArea addChild( visual )
    )

    //
    // Send any keyboard events to the focusedVisual.  Move to sendEvent()?
    //
    
    keyDown := method ( event,
      focusedVisual keyDown( event )
    )

  )

  // ------------------------------------------------------------------------ //

  //
  // The TitleBar contains the caption and close button
  //

  //Window TitleBar := Visual clone do (
  Window TitleBar := Object clone setProto( Visual ) do (

    type = "TitleBar"

    mouse := Nil

    init := method (
      resend()
      
      self reshape := list( Reshape Size, Reshape None )
      
      addChild( self closeButton := Button clone do (
        left = 3; top = 3; width = 14; height = 14

        drawVisual := method (
          Graphics color( 1, 1, 1 )
          //Graphics drawSolidRect( 0, 0, width, height )
          if( desktop enteredVisual == self ) then (
            glLineWidth( 4 )
            Graphics begin( GL_LINES,
              Graphics color( 1.0, 1.0, 1.0 )
              Graphics vertex(         2.0, 2.0 ); Graphics vertex( width - 2.0, height - 2.0 )
              Graphics vertex( width - 2.0, 2.0 ); Graphics vertex(         2.0, height - 2.0 )
            )
            glLineWidth( 3 )
            Graphics begin( GL_LINES,
              Graphics color( 1.0, 0.25, 0.25 )
              Graphics vertex(         2.0, 2.0 ); Graphics vertex( width - 2.0, height - 2.0 )
              Graphics vertex( width - 2.0, 2.0 ); Graphics vertex(         2.0, height - 2.0 )
            )
            glLineWidth( 1 )
          ) else (
            glLineWidth( 3 )
            Graphics begin( GL_LINES,
              Graphics color( 0.3, 0.3, 0.3 )
              Graphics vertex(         2.0, 2.0 ); Graphics vertex( width - 2.0, height - 2.0 )
              Graphics vertex( width - 2.0, 2.0 ); Graphics vertex(         2.0, height - 2.0 )
            )
            glLineWidth( 1 )
          )
        )

        drawBorder := Nil
      ))

      closeButton xaction = list( self, "closeWindow" )

      addChild( self title := Label clone do (
        font = Label boldFont
        text = "Untitled"
        align = Align Center
        reshape = list( Reshape Size, Reshape None )
        width = 90; height = 20
      ))
    )

    animateClose := method (
      while( parent scale > .01,
        parent scale = parent scale - .01
        //yield
        Inertia desktop display()
      )
      parent parent removeChild( parent )
    )

    closeWindow := method (
      animateClose()
      //parent parent removeChild( parent )
    )

    drawVisual := method (
      Graphics begin( GL_QUADS,
        if( parent isFocused, Graphics color( 0.9, 0.95, 1.0 ), Graphics color( 1.0, 1.0, 1.0 ) )
        Graphics vertex(     0,      0 )
        Graphics vertex( width,      0 )
        if( parent isFocused, Graphics color( 0.6, 0.8, 1.0 ), Graphics color( 0.85, 0.85, 0.85 ) )
        Graphics vertex( width, height )
        Graphics vertex(     0, height )
      )
    )

    drawBorder := Nil

    mouseDown := method ( event, self mouse = event )

    mouseUp := method ( event, self mouse = Nil )

    mouseMove := method ( event,
      if( mouse,
        parent left = parent left + (event x - mouse x)
        parent top  = parent top  + (event y - mouse y)
        glutPostRedisplay()
      )
    )

  )

  // ------------------------------------------------------------------------ //

  //
  // The clientArea is where normal visuals live
  //

  Window ClientArea := Object clone setProto( Visual ) do (

    type := "ClientArea"

    init := method (
      resend()

      left = 0; width = 400; top = 20; height = 280
      reshape = list( Reshape Size, Reshape Size )
    )

    drawVisual := method (
      Graphics color( 0.97, 0.97, 0.97 )
      Graphics drawSolidRect( 0, 0, width, height )
    )

    drawBorder := Nil

  )

  // ------------------------------------------------------------------------ //

  //
  // The Sizer visual resized a Window
  //
  
  Window Sizer := Object clone setProto( Button ) do (

    mouse := Nil

    init := method (
      resend()
      reshape = list( Reshape Move, Reshape Move )
    )

    containsPoint := method ( x, y,
      ( x + y >= width ) and ( x < width ) and ( y < height )
    )

    mouseDown := method ( event,
      self mouse = event
      self origTexId := parent textureId
      parent textureId = Window largeTexId
    )

    mouseUp := method ( event,
      self mouse = Nil
      parent textureId = origTexId
      parent sizeChanged = 1
    )

    mouseMove := method ( event,
      if( mouse,
        parent resizeBy( event x - mouse x, event y - mouse y )
        parent invalidate()
        Screen display()
      )
    )

    drawVisual := method (
      Graphics begin( GL_LINES,
        Graphics color( 0.8, 0.8, 0.8 )
        Graphics vertex(  2, height - 2 ); Graphics vertex( width - 2,  2 )
        Graphics vertex(  6, height - 2 ); Graphics vertex( width - 2,  6 )
        Graphics vertex( 10, height - 2 ); Graphics vertex( width - 2, 10 )
        Graphics vertex( 14, height - 2 ); Graphics vertex( width - 2, 14 )
      )
    )

    drawBorder := Nil
    
  )

)

