//
// Rocks.io 1.0 - 2005 Mike Austin
//

DEGREES := Number constants pi / 180

// -------------------------------------------------------------------------- //

Actor := Object clone appendProto( OpenGL ) do (

  radius  := 1.0
  speed   := 0.00001
  destroy := Nil

  actorPoints := list()  

  init := method (
    self position := Vector clone set( 0, 0, 0 )
    self velocity := Vector clone set( 0, 0, 0 )
    self rotation := Vector clone set( 0, 0, 90 )
  )

  draw := method (
    glPushMatrix()
      glTranslated( position x, position y, 0 )
      glRotated( rotation z, 0, 0, 1 )
      drawActor()
    glPopMatrix()
  )
  
  tick := method (
    position += velocity
                                    
    if( position x < -400 or position x > 400, position setX( -position x ) )
    if( position y < -300 or position y > 300, position setY( -position y ) )
    
    tickActor()
  )

  drawActor := method (
    actorPoints drawVector()
  )

  tickActor := Nil
  collidedWith := Nil
)

// -------------------------------------------------------------------------- //

Ship := Actor clone do (

  type   := "Ship"
  radius := 15
  fired  := Nil
  spin   := 0

  shipPoints   := list( list( vector(1,1,0), 15,1, -12,10, -6,0, -12,-10, 15,1 ) )
  thrustPoints := list( list( vector(1,1,0), 15,1, -12,10, -6,0, -12,-10, 15,1 ),
                        list( vector(1,0,0), -10,6, -15,0, -10,-6 ) )

  actorPoints := shipPoints

  init := method (
    resend()
    self prependProto( Normal )
  )

  Normal  := Object clone
  Explode := Object clone

  Normal tickActor := method (
    if( Control at("a"), rotation += 8 )
    if( Control at("d"), rotation -= 8 )
    if( Control at("w") ) then (
      self velocity += (vector( (rotation z * DEGREES) cos,
                                (rotation z * DEGREES) sin ) * 0.25)
      self actorPoints = thrustPoints
    ) else (
      self actorPoints = shipPoints
    )
    if( Control at(" ") and (fired == Nil) ) then (
      shot := Shot clone
      shot position = (position + vector( (rotation z * DEGREES) cos,
                                          (rotation z * DEGREES) sin ) * (radius + 5))
      shot velocity = (velocity + vector( (rotation z * DEGREES) cos,
                                          (rotation z * DEGREES) sin ) * 10)
      shot rotation = rotation clone
      Rocks actors append( shot )
      self fired = 1
    )
    if( Control at(" ") == Nil ) then (
      self fired := Nil
    )
  )

  Normal collidedWith := method ( actor,
    self spin = 100
    self removeProto( Normal ) prependProto( Explode )
  )

  Explode tickActor := method (
    rotation += spin
    self spin = spin - 5
    if( spin <= 0 ) then (
      position = vector( 0, 0, 0 )
      velocity = vector( 0, 0, 0 )
      rotation = vector( 0, 0, 90 )
      Rocks lives = Rocks lives - 1
      self removeProto( Explode ) prependProto( Normal )
    )
  )

)

// -------------------------------------------------------------------------- //

Rock := Actor clone do (

  type := "Rock"
  radius := 30

  init := method (
    resend()
    while( vector( 0, 0, 0 ) distanceTo( position ) < ((radius + Ship radius) * 3),
      position set( Random value( -400, 400 ), Random value( -300, 300 ) )
    )
    velocity set( Random value( -2.0, 2.0 ), Random value( -2.0, 2.0 ), 0.0 )
  )

  actorPoints := list( list( vector(1,.75,.0), -30,-20, -30,20, 5,30, 30,0, 5,-30, -30,-20 ) )
  smallPoints := list( list( vector(1,.75,.0), -15,-10, -15,10, 2,15, 15,0, 2,-15, -15,-10 ) )

  tickActor := method (
    rotation += vector( 0.0, 0.0, -1.0 )
  )

  breakApart := method (
    actorPoints = smallPoints
    radius = 15
    position += vector( Random value( -radius, radius ), Random value( -radius, radius ) )
    velocity = vector( Random value( -2, 2 ), Random value( -2, 2 ) )

    rock := Rock clone
    rock actorPoints = smallPoints
    radius = 15
    rock position = position + vector( Random value( -radius, radius ), Random value( -radius, radius ) )
    rock velocity = vector( Random value( -2, 2 ), Random value( -2, 2 ) )
    Rocks rocks append( rock )
  )

  collidedWith := method ( actor,
    if( (actor type == "Shot") or (actor type == "Ship") ) then (
      if( actorPoints != smallPoints ) then (
        breakApart()
      ) else (
        self destroy = 1
      )
    )
  )
  
)
// -------------------------------------------------------------------------- //

Shot := Actor clone do (

  type := "Shot"
  radius = 5.0
  ttl := 50

  actorPoints := list( list( vector(0,1,1), 0,0, 5,0 ) )

  tickActor := method (
    self ttl = ttl - 1
    if( ttl < 0 ) then (
      self destroy = 1
    )
  )

  collidedWith := method ( actor,
    if( actor type == "Rock" ) then ( Rocks score = Rocks score + 10 )
    self destroy = 1
  )

)  

// -------------------------------------------------------------------------- //

Control := Map clone

Numbers := Map clone do (
  atPut( "0", list( list( vector(0,1,1), 0,0, 0,50, 50,50, 50,0, 0,0 ) ) )
  atPut( "1", list( list( vector(0,1,1), 50,0, 50,50 ) ) )
  atPut( "2", list( list( vector(0,1,1), 0,50, 50,50, 50,25, 0,25, 0,0, 50,0 ) ) )
  atPut( "3", list( list( vector(0,1,1), 0,50, 50,50, 50,0, 0,0 ), list( vector(0,1,1), 0,25, 50,25 ) ) )
  atPut( "4", list( list( vector(0,1,1), 0,50, 0,25, 50,25 ), list( vector(0,1,1), 50,50, 50,0 ) ) )
  atPut( "5", list( list( vector(0,1,1), 50,50, 0,50, 0,25, 50,25, 50,0, 0,0 ) ) )
  atPut( "6", list( list( vector(0,1,1), 0,50, 0,0, 50,0, 50,25, 0,25 ) ) )
  atPut( "7", list( list( vector(0,1,1), 0,50, 50,50, 50,0 ) ) )
  atPut( "8", list( list( vector(0,1,1), 0,0, 0,50, 50,50, 50,0, 0,0 ), list( vector(0,1,1), 0,25, 50,25 ) ) )
  atPut( "9", list( list( vector(0,1,1), 50,0, 50,50, 0,50, 0,25, 50,25 ) ) )
)

List drawModes := list( OpenGL GL_LINE_STRIP, OpenGL GL_POINTS )
List drawVector := method (
  drawModes foreach ( mode,
    self foreach( segment,
      OpenGL glBegin( mode )
        for( i, 1, segment size - 1, 2,
          OpenGL glColor4d( segment at(0) red, segment at(0) green, segment at(0) blue, Random value( 0.35, .65 ) )
          OpenGL glVertex2d( segment at(i), segment at(i+1) )
        )
      OpenGL glEnd()
    )
  )
)

// -------------------------------------------------------------------------- //

Rocks := Object clone appendProto( OpenGL ) do (

  lives     := 3
  rockCount := 0
  score     := 0

  init := method (
    glutInit()
    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE )
    glutInitWindowPosition( 200, 100 )
    glutInitWindowSize( 800, 600 )
    glutCreateWindow( "Rocks-Io" )
    glutIgnoreKeyRepeat( 1 )
    
    glutEventTarget( self )
    glutReshapeFunc()
    glutDisplayFunc()
    glutKeyboardFunc()
    glutKeyboardUpFunc()

    glEnable( GL_LINE_SMOOTH ); glLineWidth( 1.5 )
    glEnable( GL_POINT_SMOOTH ); glPointSize( 1.5 )
    glEnable( GL_BLEND ); glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )

    Random setSeed( Date now second )
    
    self actors := list( self player := Ship clone )
    self rocks := list()
    self
  )
  
  run := method (
    glutTimerFunc( 1000 / 30, 1000 / 30 )
    glutMainLoop()
  )

  drawScore := method (
    Rocks score asString foreach( digit,
      Numbers at(digit asCharacter) drawVector()
      glTranslated( 60, 0, 0 )
    )
  )
  
  // ------------------------------------------------------------------------ //
  
  timer := method ( value,
    glutTimerFunc( value, value )
    actors foreach( actor, actor tick )
    rocks foreach( rock, rock tick )

    actors foreach( actor,
      rocks foreach( rock,
        if( actor position distanceTo( rock position ) < (actor radius + rock radius) ) then (
          actor collidedWith( rock )
          rock collidedWith( actor )
        )
      )
    )

    actors foreach( actor, if( actor destroy, actors remove( actor ) ) )
    rocks foreach( rock, if( rock destroy, rocks remove( rock ) ) )
    
    if( actors size + rocks size == 1 ) then (
      self rockCount = rockCount + 3
      for( i, 1, rockCount,
        rocks append( Rock clone )
      )
    )
    
    if( lives == -1 ) then (
      self score = 0
      self lives = 3
    )
    
    glutPostRedisplay()
  )
  
  reshape := method ( width, height,
    glMatrixMode( GL_PROJECTION )
      glLoadIdentity()
      gluOrtho2D( -400, 400, -300, 300 )
    glMatrixMode( GL_MODELVIEW )
  )
  
  display := method (
    glClear( GL_COLOR_BUFFER_BIT )
    glLoadIdentity()
    actors foreach( actor, actor draw )
    rocks foreach( rock, rock draw )
    
    glPushMatrix()
      glTranslated( -390, 240, 0 )
      drawScore()
    glPopMatrix()

    glTranslated( 340, 240, 0 )
    lives asString foreach( digit,
      Numbers at(digit asCharacter) drawVector()
      glTranslated( 60, 0, 0 )
    )

    glutSwapBuffers()
  )

  keyboard := method ( key, x, y,
    Control atPut( key asCharacter, 1 )
  )

  keyboardUp := method ( key, x, y,
    Control atPut( key asCharacter, Nil )
  )
 
)

Rocks init run
