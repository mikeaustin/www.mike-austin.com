//
// MenuPane.io
//

writeln( "[Menu.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  MenuPane := Object clone setProto( Visual ) do (

    type := "MenuPane"
  
    lastPos := 0
    maxWidth := 0

    init := method (
      resend()
      height = 0
    )
    
    addItem := method ( visual,
      visual top = lastPos
      self lastPos = lastPos + visual height
      addChild( visual )

      maxWidth = maxWidth max (visual width)

      subnodes foreach( node,
        node width = maxWidth
      )

      self width  = maxWidth
      self height = height + visual height
    )

    popup := method ( parent, x, y,
      writeln( "here" )
      left = x
      top  = y
      parent addChild( self )
    )
    
  )

  // ------------------------------------------------------------------------ //

  MenuButton := Object clone setProto( Button ) do (
  
    init := method (
      resend()
      height = 20
      self caption := attr( "" ) do (
        //self caption do ( // Should work, doesn't
        set := method ( value, context label text = value; context resize() )
        get := method ( context label text )
      )
      label left = 5
      label align = Align Left
      //label autoSize = 1
      self subMenu := Nil
    )

    resize := method (
      width = label font widthOfString( label text ) + 10
    )

    drawVisual := method (
      if( desktop enteredVisual == self ) then (
        Graphics color( 0.6, 0.8, 1.0 )
        Graphics drawSolidRect( 0, 0, width, height )
      ) else (
        Graphics color( 0.97, 0.97, 0.97 )
        Graphics drawSolidRect( 0, 0, width, height )
      )
    )

    drawBorder := Nil

    mouseDown := method ( event,
      if( subMenu ) then (
        //subMenu left = screenLeft
        //subMenu top = screenTop + height + 1
        subMenu popup( desktop, screenLeft, screenTop + height + 1 )
        //Inertia desktop addChild( subMenu )
      )
    )

    mouseUp := method ( event,
      resend()
      if( (subMenu == Nil) and (parent type != "MenuBar") ) then (
        parent parent removeChild( parent )
      )
    )
  
  )
  
  // ------------------------------------------------------------------------ //
  
  MenuItem := Object clone setProto( Button ) do (
  
    init := method (
      resend()
      height = 20
      self caption := attr( "" ) do (
        //self caption do ( // Should work, doesn't
        set := method ( value, context label text = value; context resize() )
        get := method ( context label text )
      )
      label left = 20
      label align = Align Left
      //label autoSize = 1
      self subMenu := Nil
    )

    resize := method (
      width = label font widthOfString( label text ) + 40
    )

    drawVisual := method (
      if( desktop enteredVisual == self ) then (
        Graphics color( 0.6, 0.8, 1.0 )
        Graphics drawSolidRect( 0, 0, width, height )
      ) else (
        Graphics color( 0.97, 0.97, 0.97 )
        Graphics drawSolidRect( 0, 0, width, height )
      )
      if( subMenu ) then (
        Graphics color( 0.4, 0.4, 0.4 )
        Graphics begin( GL_TRIANGLES,
          Graphics vertex( width - 13, height / 2 - 5 )
          Graphics vertex( width - 5,      height / 2 )
          Graphics vertex( width - 13, height / 2 + 5 )
        )
        Graphics translate( 0.5, 0.5 )
        Graphics begin( GL_LINE_LOOP,
          Graphics vertex( width - 13, height / 2 - 5 )
          Graphics vertex( width - 5 - 1,      height / 2 - 0.5 )
          Graphics vertex( width - 13, height / 2 + 5 - 1 )
        )
        Graphics translate( -0.5, -0.5 )
      )
    )

    drawBorder := Nil

    mouseDown := method ( event,
      if( subMenu ) then (
        subMenu left = screenLeft + width + 1
        subMenu top = screenTop
        Inertia desktop addChild( subMenu )
      )
    )

    mouseUp := method ( event,
      resend()
      if( (subMenu == Nil) and (parent type != "MenuBar") ) then (
        parent parent removeChild( parent )
      )
    )
  
  )

  // ------------------------------------------------------------------------ //

  MenuBar := Object clone setProto( Visual ) setType( "MenuBar" ) do (

    lastPos := 5
    
    init := method (
      resend()
      width = 400; height = 20
      reshape = list( Reshape Size, Reshape None )
    )

    addItem := method ( visual,
      visual left = lastPos
      self lastPos = lastPos + visual width
      addChild( visual )
    )

    drawVisual := method (
      Graphics color( 0.97, 0.97, 0.97 )
      Graphics drawSolidRect( 0, 0, width, height )
    )

  )
  
)

