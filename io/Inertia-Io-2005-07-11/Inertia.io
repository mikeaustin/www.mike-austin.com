//
// Inertia.io - 2005 Mike Austin
//

Importer turnOff

Lobby type := "Lobby"

Nil foreach := Nil
Nil reverseForeach := Nil

Object setType := method ( type, self type := type; self )

Inertia := Object clone do ( type := "Inertia" )
appendProto( Inertia )

doFile( launchPath appendPath( "Utils.io" ) )

OpenGL glutInit()

// -------------------------------------------------------------------------- //

//
// This is the main object that initializes the system and handles glut events
//

Inertia appendProto( OpenGL ) do (

  stickyWindows := list()

  init := method (
    writeln( "Initializing Inertia..." )
    resend()

    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH | GLUT_ALPHA )
    glutInitWindowPosition( 200, 100 )
    glutInitWindowSize( 1024, 768 )
    glutCreateWindow( "Inertia-Io" )
    
    glutDisplayFunc()
    glutReshapeFunc()
    glutMouseFunc()
    glutMotionFunc()
    glutPassiveMotionFunc()
    glutKeyboardFunc()
    glutEventTarget( Screen )

    glClearColor( 1.0, 1.0, 1.0, 1.0 )
    glEnable( GL_BLEND ); glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )
    glEnable( GL_LINE_SMOOTH )

    glGetDoublev( GL_ALPHA_BITS, alphaBits := list() )
    writeln( "OpenGL ", glGetString( GL_VERSION ), " ", glGetString( GL_VENDOR ),
             " ", glGetString( GL_RENDERER ), " destAlpha: ", alphaBits at(0) )

    writeln( "Loading Objects..." )
    Lobby do (
      doFile( "Model.io" )
      doFile( "Event.io" )
      doFile( "Graphics.io" )
      doFile( "Visual.io" )
      doFile( "Visuals/Desktop.io" )
      doFile( "Visuals/Label.io" )
      doFile( "Visuals/Button.io" )
      doFile( "Visuals/TextField.io" )
      doFile( "Visuals/TextEdit.io" )
      doFile( "Visuals/Menu.io" )
      doFile( "Visuals/Slider.io" )
      doFile( "Visuals/Table.io" )
      doFile( "Visuals/Window.io" )
      doFile( "Visuals/Movie.io" )
      doFile( "Visuals/LoginPanel.io" )
      doFile( "Models/FolderModel.io" )
      doFile( "Models/StoreModel.io" )
      doFile( "Models/ObjectModel.io" )
      doFile( "Models/ContactModel.io" )
    )

    self screen := list( Desktop clone do ( width = 1024; height = 768 ),
                         Desktop clone do ( width = 1024; height = 768 ) )
    self desktop := screen at(0)

    start()

    self
  )

  //
  // Initialize stuff that needs a glut window to be open
  //
  
  start := method (
    writeln( "Loading Apps..." )
    desktop addChild( doFile( "Apps/Calculator.io" ) clone )
    desktop addChild( LoginPanel clone )
    clock := Lobby doFile( "Apps/Clock.io" ) clone
    stickyWindows add( clock )
    screen at(1) addChild( clock )
    desktop addChild( clock )

    inertia := MenuButton clone do ( left = 5; caption = "Inertia" )
    inertia subMenu = MenuPane clone

    launchApp := MenuItem clone do ( caption = "Run China.io" )
    launchApp addAction( self, "launchApp", "Apps/China.io" )
    inertia subMenu addItem( launchApp )
    check := CheckButton clone do ( caption = "Yes, Send me spam please" )
    inertia subMenu addItem( check )
    launchApp = MenuItem clone do ( caption = "Run Mail.io" )
    launchApp addAction( self, "launchApp", "Apps/Mail.io" )
    inertia subMenu addItem( launchApp )
    launchApp = MenuItem clone do ( caption = "Run IRC.io" )
    launchApp addAction( self, "launchApp", "Apps/InertiaIRC.io" )
    inertia subMenu addItem( launchApp )

    window := MenuButton clone do ( left = 5; caption = "Window" )

    menuBar := MenuBar clone do ( width = 1024 + 1; height = 20 )
    menuBar addItem( inertia )
    menuBar addItem( window )
    stickyWindows add( menuBar )
    screen at(1) addChild( menuBar )
    desktop addChild( menuBar )

    visual := Button clone do ( caption = "Desktop 1"; left = 700 )
    visual addAction( self, "switchDesktop", 1 )
    menuBar addChild( visual )
    visual := Button clone do ( caption = "Desktop 2"; left = 790 )
    visual addAction( self, "switchDesktop", 2 )
    menuBar addChild( visual )

    desktop addChild( Lobby doFile( "Apps/Designer.io" ) clone )

    writeln( "Inertia started." )
  )

  switchDesktop := method ( sender, data,
    desktop = screen at(data - 1)
    stickyWindows foreach( window,
      window parent = desktop
    )
  )

  launchApp := method ( sender, app,
    Importer turnOn
    desktop addChild( Lobby doFile( app ) clone )
    Importer turnOff
  )

  //
  // Set up the timer and enter glut's main loop
  //

  run := method (
    glutTimerFunc( 0, 10 )
    glutMainLoop()
  )

)

// -------------------------------------------------------------------------- //

//
// glut callbacks
//

Screen := Object clone do (

  //
  // display() gets called whenever the screen needs to be updated
  //
  
  display := method (
    glClear( GL_COLOR_BUFFER_BIT )
    glLoadIdentity()

    desktop drawVisual()
    desktop display()
    
    glutSwapBuffers()
  )

  //
  // Called when the glut window is resized
  //

  reshape := method ( width, height,
    glMatrixMode( GL_PROJECTION )
      glLoadIdentity()
      gluOrtho2D( 0, width, height, 0 )
    glMatrixMode( GL_MODELVIEW )
    glViewport( 0, 0, width, height )
  )

  //
  // Called when the glut window receives mouse input
  //

  mouse := method ( button, state, x, y,
    if( state == 0, desktop sendEvent( MouseEvent:( "mouseDown", button, x, y, glutGetModifiers() ) ) )
    if( state == 1, desktop sendEvent( MouseEvent:( "mouseUp", button, x, y, glutGetModifiers() ) ) )
    glutPostRedisplay()
  )

  //
  // Called when the glut window receives mouse input
  //
  
  motion := method ( x, y,
    desktop sendEvent( MouseEvent:( "mouseMove", Nil, x, y, glutGetModifiers() ) )
    //glutPostRedisplay()
  )

  passiveMotion := getSlot("motion")

  //
  // Called when the glut window received keyboard input
  //

  keyboard := method ( key, x, y,
    desktop sendEvent( KeyEvent:( "keyDown", key, glutGetModifiers() ) )
    glutPostRedisplay()
  )

  //
  // A glut timer with a yield() is required for coroutines to work properly
  //

  timer := method ( value,
    yield()
    glutTimerFunc( value, value )
  )

)

// -------------------------------------------------------------------------- //

// Initialize Inertia and run it

Inertia init run

/*

    desktop addChild( Window clone do (
      table := Table clone
      table do ( left = 5; top = 5; width = 400; height = 300 )
      table model = ContactModel clone
      addChild( table )
      
      form := list( "John Doe", Contact clone do ( age = 20 ) )
      
      button := Button clone
      button do ( caption = "Add Contact"; left = 5; top = 310; height = 20 )
      button xxaction := Action:( table model, "addContact", form )
      addChild( button )
    
      width = 450; height = 400; sizeChanged = 1
    ))

    desktop addChild( Window clone do (
      addChild( slider := Slider clone do ( left = 5; top = 5 ) )
      addChild( slider2 := Slider clone setModel( slider model ) do ( left = 100; top = 5 ) )
      addChild( field := TextField clone setModel( slider model ) do ( left = 5; top = 100 ) )
      addChild( Inertia Movie clone do (
        left = 200; top = 5; width = 195; height = 195
        reshape = list( Reshape Size, Reshape Size )
        //@@start
      ))
      addChild( CheckButton clone do ( caption = "Yes, please send me spam"; left = 5; top = 125; height = 20 ) )
      focusedVisual = field
    ))

    desktop addChild( Window clone do (
      addChild( Table clone do (
        left = 5; top = 5; width = 400; height = 300
        model = FolderModel clone
      ))
      width = 450; height = 400; sizeChanged = 1
      Nil
    ))

*/

