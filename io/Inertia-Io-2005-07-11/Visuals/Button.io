//
// Button.io
//

writeln( "[Button.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  //Button := Visual clone do (
  Button := Object clone setProto( Visual ) do (

    type := "Button"

    target := Nil
    xaction := Nil
    xtarget := Nil
    xxaction := Nil

    init := method (
      resend()
      self caption := attr( "" ) do (
        //set := method ( value, context label text = value; context resize() )
        set := method ( value, context label text = value )
        get := method ( context label text )
      )
      addChild( self label := Label clone do (
        reshape = list( Reshape Size, Reshape Size )
        align = Align Center
      ))
      label left = 3; label width = 84
      height = 20
    )

    resize := method (
      width = label font widthOfString( label text ) + 6
    )

    drawVisual := method (
      Graphics begin( GL_QUADS,
        if( desktop enteredVisual == self, Graphics color( 0.9, 0.95, 1.0 ), Graphics color( 1.0, 1.0, 1.0 ) )
        Graphics vertex(     0,      0 )
        Graphics vertex( width,      0 )
        if( desktop enteredVisual == self, Graphics color( 0.6, 0.8, 1.0 ), Graphics color( 0.85, 0.85, 0.85 ) )
        Graphics vertex( width, height )
        Graphics vertex(     0, height )
      )
    )

    mouseDown := method ( event, self mouse = event )

    mouseUp := method ( event,
      if( self target ) then (
        event target := self
        self target actionPerformed( event )
        self mouse = Nil
      )

      if( self getSlot("xaction") ) then (
        event target := self
        xaction at(0) perform( xaction at(1), event )
        self mouse = Nil
      )

      if( self getSlot("xxaction") ) then (
        //xxaction at(0) perform( xxaction at(1), xxaction at(1), xxaction at(2) )
        xxaction target perform( xxaction message, self, xxaction data )
        self mouse = Nil
      )
    )

    addAction := method ( target, message, data,
      self xxaction = Action:( target, message, data )
    )

  )

  // ------------------------------------------------------------------------ //

  //CheckButton := Button clone do (
  CheckButton := Object clone setProto( Button ) do (

    init := method (
      resend()
      label align = Align Left
      label left = 20
      height = 20
    )

    resize := method (
      width = label font widthOfString( label text ) + 25
    )

    drawVisual := method (
      resend()
      Graphics color( 1, 1, 1 )
      Graphics drawSolidRect( 4, 4, 12, 12 )
      Graphics color( 0.8, 0.8, 0.8 )
      Graphics drawLineRect( 4, 4, 12, 12 )
    )

    drawBorder := Nil

  )
  
)

