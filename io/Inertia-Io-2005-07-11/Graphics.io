//
// Graphics.io
//

writeln( "[Graphics.io]" )

// -------------------------------------------------------------------------- //

SceneNode := Object clone appendProto( OpenGL ) do (

  init := method (
    resend()
    self subnodes := Nil
    self position := Point clone
    self dispList := 0
  )
  
  setDisplayList := method ( dispList,
    self dispList = dispList
  )

  addChildNode := method ( node,
    if( subnodes == Nil, self subnodes = List clone )
    subnodes add( node )
  )

  removeChildNode := method ( node,
    if( subnodes, subnodes remove( node ) )
  )
  
  display := SceneNode:display := method (
    subnodes foreach ( node,
      glPushMatrix()
        glTranslated( node position x, node position y, 0 )
        node drawVisual()
        if( node subnodes, node display() )
        node drawBorder()
        node invalidated = Nil
      glPopMatrix()
    )
  )
  
)

Inertia do (

  Graphics := Object clone do (

    color := method ( red, green, blue, alpha,
      //writeln( "> ", sender thisMessage name, " ", sender self )
      glColor4d( red, green, blue, if( alpha, alpha, 1 ) )
    )

    translate := method ( x, y, z,
      glTranslated( x, y, if( z, z, 0 ) )
    )
  
    vertex := method ( x, y, z,
      glVertex3d( x, y, if( z, z, 0 ) )
    )
  
    texCoord := method( s, t, r, q,
      glTexCoord4d( s, t, if( r, r, 0 ), if( q, q, 1 ) )
    )
  
    stack := method (
      glPushMatrix()
        sender doMessage( thisMessage argAt(0) )
      glPopMatrix()
    )
  
    begin := method ( mode,
      glBegin( mode )
        sender doMessage( thisMessage argAt(1) )
      glEnd()
    )        
  
    drawSolidRect := method ( left, top, width, height,
      glBegin( GL_QUADS )
        glVertex2d(         left,          top )
        glVertex2d( left + width,          top )
        glVertex2d( left + width, top + height )
        glVertex2d(         left, top + height )
      glEnd()
    )

    drawLineRect := method ( left, top, width, height,
      glPushMatrix()
      glTranslated( 0.5, 0.5, 0 )
      glBegin( GL_LINE_LOOP )
        glVertex2d(            left,               top )
        glVertex2d( left + width - 1,              top )
        glVertex2d( left + width - 1, top + height - 1 )
        glVertex2d(             left, top + height - 1 )
      glEnd()
      glPopMatrix()
    )
    
  )
  
)

