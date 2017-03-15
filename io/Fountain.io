#
# Fountain.io 1.0 - 2005 Mike Ausitn
#

Scene := Object clone do (

  parent := OpenGL

  init := method (
    self actors := List clone
  )

  addActor := method ( actor,
    actors add( actor )
  )

  advance := method (
    actors foreach( actors,
      actors advance()
    )
  )

  displayVertex := method ( displayList,
    actors foreach( actor,
      glColor4d( 1.0, 1 / (actor age / 20), 0, 1 / (actor age / 30) );
      glVertex3d( actor position x, actor position y, actor position z )
    )
  )

)

Actor := Object clone do (

  init := method (
    self position := Vector clone
    self velocity := Vector clone
    self age := 0

    reset()
  )

  reset := method (
    position set( 0, 0, 0 )
    velocity set( Random value / 200 - .0025,
                  Random value / 30  + .0025,
                  Random value / 200 - .0025 )
    self age = 0 
  )

  advance := method (
    velocity setY( velocity y - .001 )
    position += velocity

    if( position y < 0 ) then (
      if( velocity y abs < .001 ) then (
        reset()
      ) else (
        velocity setY( velocity y * -0.25 )
      )
    )

    self age = age + 1
  )

)

Screen := Object clone do (

  parent := OpenGL

  timer := method (
    scene advance()
    glutPostRedisplay()
    glutTimerFunc( 10, 10 )
  )

  display := method (
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )

    glLoadIdentity()
    glTranslated( 0, -.3, -1 )

    glBegin( GL_POINTS )
      scene displayVertex( 100 )
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
    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH )
    glutInitWindowPosition( 200, 100 )
    glutInitWindowSize( 200, 300 )
    glutCreateWindow( "Particles" )

    glutDisplayFunc( display )
    glutReshapeFunc( reshape )
    glutEventTarget( self )

    glEnable( GL_BLEND ); glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    glEnable( GL_POINT_SMOOTH ); glPointSize( 3 )

    glNewList( 100, GL_COMPILE )
      glVertex3d( 0, 0, 0 )
    glEndList()

    self scene := Scene clone

    for( i, 1, 1000,
      scene addActor( Actor clone )
    )
  )

  run := method (
    glutTimerFunc( 10, 10 )
    glutMainLoop()
  )

)

Screen clone run

