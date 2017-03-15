//
// MassSpring.io - 2004 Mike Austin
//

time := 0

RigidBody := Object clone do (

  parent := OpenGL

  objects := List clone

  init := method (
    glutInit();
    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE )
    glutInitWindowSize( 800, 600 )
    glutInitWindowPosition( 200, 100 )
    glutCreateWindow( "RigidBody" )

    glutEventTarget( self )
    glutDisplayFunc(); glutReshapeFunc()

    glEnable( GL_BLEND ); glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )
    glEnable( GL_LINE_SMOOTH ); glLineWidth( 1.5 )
  )

  addObject := method ( object,
    objects addIfAbsent( object )
  )

  display := method (
    glClear( GL_COLOR_BUFFER_BIT )
    glLoadIdentity()

    objects foreach( mass,
      glPushMatrix()    
        mass tick
        mass draw
      glPopMatrix()
    )
        
    glutSwapBuffers()
  )

  reshape := method (
    glMatrixMode( GL_PROJECTION )
    glLoadIdentity()
    gluOrtho2D( -400, 400, -300, 300 )
    glMatrixMode( GL_MODELVIEW )
    glViewport( 0, 0, 800, 600 )
  )
  
  timer := method (
    time = time + 1
    glutTimerFunc( 10, 0 )
    glutPostRedisplay()
  )

  run := method (
    glutTimerFunc( 0, 0 )
    glutMainLoop()
  )

)

//
// ----------------------------------------------------------------------------
//

Mass := Object clone do (

  parent := OpenGL

  mass     := 1.0
  springs  := Nil
  position := Point clone
  velocity := Point clone

  init := method (
    self position := Point clone set( (Number random - .5) * 400, (Number random - .5) * 300 )
    self velocity := Point clone set( Number random - .5, Number random - .5 )
    //write( velocity, "\n" )
    self springs = List clone
  )

  setPosition := method ( x, y,
    self position setX( x )
    self position setY( y )
    self
  )

  setVelocity := method ( x, y,
    self velocity setX( x )
    self velocity setY( y )
    self
  )

  connectMass := method ( mass,
    Spring clone connectMasses( self, mass, 10 )
  )

  tick := method (
    //write( "> Mass tick()\n" )
    self position = position + velocity
    mass := self
    if( mass position x < -400, mass velocity setX( - (mass velocity x) ) )
    if( mass position x > 400, mass velocity setX( - (mass velocity x) ) )
    if( mass position y < -300, mass velocity setY( - (mass velocity y) ) )
    if( mass position y > 300, mass velocity setY( - (mass velocity y) ) )
    //write( "< Mass tick()\n" )
  )

  draw := method (
    glTranslated( position x, position y, 0 )
    glBegin( GL_QUADS )
      glVertex2d( -5, -5 )
      glVertex2d(  5, -5 )
      glVertex2d(  5,  5 )
      glVertex2d( -5,  5 )
    glEnd()
  )

)

//
// ----------------------------------------------------------------------------
//

Spring := Object clone do (

  parent := OpenGL

  mass1 := Nil
  mass2 := Nil
  distance := 0

  deltapos := Point clone
  deltavel := Point clone

  connectMasses := method ( mass1, mass2, distance,
    self mass1 = mass1
    self mass2 = mass2
    self distance := distance
    mass1 springs add( self )
    mass2 springs add( self )
    RigidBody addObject( self )
  )

  tick := method (
    //write( "> Spring tick()\n" )
    deltapos := mass1 position - mass2 position
    deltavel := mass1 velocity - mass2 velocity
    
    angle := deltapos y atan2( deltapos x ) - deltavel y atan2( deltavel x )

    xvel := deltavel x * angle cos - deltavel y * angle sin
    yvel := deltavel y * angle cos + deltavel x * angle sin
    
    mass1 velocity setX( mass1 velocity x - (xvel / 100) )
    mass1 velocity setY( mass1 velocity y - (yvel / 100) )
    mass2 velocity setX( mass2 velocity x + (xvel / 100) )
    mass2 velocity setY( mass2 velocity y + (yvel / 100) )
    
    //write( angle / (Number pi / 180), " ", xvel, " ", yvel, "\n" )
    //write( "< Spring tick()\n" )
  )
  
  draw := method (
    glBegin( GL_LINES )
      glVertex2d( mass1 position x, mass1 position y )
      glVertex2d( mass2 position x, mass2 position y )
    glEnd()
  )

)

//
// ----------------------------------------------------------------------------
//

mass1 := Mass clone
mass2 := Mass clone
mass3 := Mass clone

mass1 connectMass( mass2 )
mass1 connectMass( mass3 )
mass2 connectMass( mass3 )
mass1 connectMass( mass4 := Mass clone )
mass2 connectMass( mass5 := Mass clone )
mass3 connectMass( mass6 := Mass clone )

RigidBody addObject( mass1 )
RigidBody addObject( mass2 )
RigidBody addObject( mass3 )
RigidBody addObject( mass4 )
RigidBody addObject( mass5 )
RigidBody addObject( mass6 )

RigidBody clone run

