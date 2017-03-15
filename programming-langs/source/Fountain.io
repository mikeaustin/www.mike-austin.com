#
# Fountain.io 1.0 - 2005 Mike Ausitn
#

gravity := Vector clone set( 0, -0.001, 0 )

Actor := Object clone appendProto( OpenGL ) do (

  init := method (
    self subnodes := List clone
    self position := Vector clone
    self velocity := Vector clone
    self age := 0

    reset()
  )

  addChildNode := method ( node,
    subnodes append( node )
    self
  )

  setVelocity := method ( x, y, z,
    velocity set( x, y, z )
    self
  )

  reset := method (
    position set( 0, 0, 0 )
    velocity set( Random value * 0.005 - 0.0025,
                  Random value * 0.025 + 0.0075,
                  Random value * 0.005 - 0.0025 )
    self age = 0 
  )

  display := method (
    subnodes foreach( node,
      node velocity += gravity
      node position += node velocity

      if( node position y < 0 ) then (
        if( node velocity y < -0.001 ) then (
          node velocity setY( node velocity y * -0.25 )
        ) else (
          node reset()
        )
      )

      node age = node age + 1

      glColor4d( 1.0, 1 / (node age / 20), 0, 1 / (node age / 30) );
      glVertex3d( node position x, node position y, node position z )
    )
  )

)

// -------------------------------------------------------------------------- //

Screen := Object clone appendProto( OpenGL ) do (

  timer := method ( value,
    glutTimerFunc( value, value )
    glutPostRedisplay()
  )

  display := method (
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )

    glLoadIdentity()
    glTranslated( 0.0, -0.3, -1.0 )

    glBegin( GL_POINTS )
      scene display()
    glEnd()

    glutSwapBuffers()
  )

  reshape := method ( width, height,
    glMatrixMode( GL_PROJECTION )
      glLoadIdentity()
      gluPerspective( 45, width / height, 1, 100 )
    glMatrixMode( GL_MODELVIEW )
    glViewport( 0, 0, width, height )
  )

  init := method (
    glutInit()
    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE )
    glutInitWindowPosition( 200, 100 )
    glutInitWindowSize( 200, 300 )
    glutCreateWindow( "Fountain.io" )

    glutDisplayFunc( display )
    glutReshapeFunc( reshape )
    glutEventTarget( self )

    glEnable( GL_BLEND ); glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    glEnable( GL_POINT_SMOOTH ); glPointSize( 3 )

    self scene := Actor clone setVelocity( 0, 0, 0 )

    for( i, 1, 1000,
      scene addChildNode( Actor clone )
    )
  )

  run := method (
    glutTimerFunc( 1000 / 60, 1000 / 60 )
    glutMainLoop()
  )

)

Screen clone run
