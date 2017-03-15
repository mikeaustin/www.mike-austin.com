//
// Designer
//

DesignerView := Object clone setProto( Visual ) do (

  mouse := Nil
  visual := Nil
  scale := 2

  drawVisual := method (
/*
      desktop background bindTexture()
      glEnable( GL_TEXTURE_2D )
      Graphics begin( GL_QUADS,
        Graphics texCoord( 0.0, .75 ); Graphics vertex(     0,   0 )
        Graphics texCoord( 1.0, .75 ); Graphics vertex( desktop width,   0 )
        Graphics texCoord( 1.0, 0.0 ); Graphics vertex( desktop width, 768 )
        Graphics texCoord( 0.0, 0.0 ); Graphics vertex(     0, 768 )
      )
      glDisable( GL_TEXTURE_2D )
*/
    Graphics stack (
      glTranslated( -screenLeft, -screenTop, 0 )
      //glScaled( 2, 2, 0 )
      //glTranslated( -screenLeft * (1024 / width), -screenTop * ((768 / height) * 2), 0 )
      designerDisplay( desktop )
    )
/*
        if( node type == "ClientArea" ) then (
          glLineStipple( 1, 0x8080 )
          glEnable( GL_LINE_STIPPLE )
          Graphics color( .75, .75, .75 )
          Graphics begin( GL_LINES,
            for( y, 0, height, 8,
              Graphics vertex( 0, y )
              Graphics vertex( width, y )
            )
          )
          glDisable( GL_LINE_STIPPLE )
        )
*/
  )

  designerDisplay := method ( root,
    root subnodes foreach ( node,
      if( node == self parent parent, continue )
      glPushMatrix()
        glTranslated( node position x, node position y, 0 )
        if( node parent == desktop, node drawVisual() )
        if( node subnodes, designerDisplay( node ) )
        node drawBorder()
        glLineWidth( 1 )
        if( node == visual ) then (
          Graphics color( 1, 0, 0 )
          Graphics drawLineRect( 0 - 1, 0 - 1, node width + 2, node height + 2 )
          Graphics drawSolidRect( 0, 0, 5, 5 )
          Graphics drawSolidRect( 0, visual height / 2 - 5 / 2, 5, 5 )
          Graphics drawSolidRect( visual width / 2 - 5 / 2, 0, 5, 5 )
          Graphics drawSolidRect( visual width - 5, 0, 5, 5 )
          Graphics drawSolidRect( visual width - 5, visual height - 5, 5, 5 )
          Graphics drawSolidRect( visual width / 2 - 5 / 2, visual height - 5, 5, 5 )
          Graphics drawSolidRect( visual width - 5, visual height / 2 - 5 / 2, 5, 5 )
          Graphics drawSolidRect( 0, visual height - 5, 5, 5 )
        )
        glLineWidth( 1 )
      glPopMatrix()
    )
  )

  mouseDown := method ( event,
    self visual = myVisualAt( desktop, event x + screenLeft, event y + screenTop )
    if( visual type == "Desktop", continue )

    self mouse = event

    if( visual type == "TitleBar" ) then (
      visual = visual parent
    )

    mouse x = visual left - event x
    mouse y = visual top - event y

    parent parent inspector model object = visual
    parent parent inspector model cache = Nil
    parent parent inspector invalidate()
  )

  mouseMove := method ( event,
    if( mouse ) then (
      visual left = (((event x + mouse x) / 5) roundDown * 5)
      visual top = (((event y + mouse y) / 5) roundDown * 5)

      visual invalidate()
      invalidate()

      parent parent inspector model object = visual
      parent parent inspector model cache = Nil
      parent parent inspector invalidate()
      glutPostRedisplay()
    )
  )

  mouseUp := method (
    self mouse = Nil
  )

  myVisualAt := method ( root, x, y,
    root subnodes reverseForeach ( visual,
      if( visual == self parent parent, continue )
      if( visual containsPoint( x - visual left, y - visual top ) ) then (
        return myVisualAt( visual, x - visual left, y - visual top )
      )
    )
    return root
  )
  
)

Designer := Object clone setProto( Window ) do (

  init := method (
    resend()
    caption = "X-Ray"
    addChild( DesignerView clone do (
      width = 200; height = 300
      reshape = list( Reshape Size, Reshape Size )
    ))
    addChild( self inspector := Table clone do (
      left = 200; top = 0; width = 200; height = 400
      reshape = list( Reshape Move, Reshape Size )
      model = PropertyModel clone
    ))
    width = 800; height = 600; sizeChanged = 1
    
    titleBar mouseMove := method (
      resend()
      invalidate()
    )
  )

)

