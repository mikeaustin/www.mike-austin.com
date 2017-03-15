//
// Visual.io
//

writeln( "[Visual.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  //Reshape := Object clone do ( None := 0; Move := 1; Size := 2; Pack := 3 )
  Reshape := Object clone do ( None := "None"; Move := "Move"; Size := "Size"; Pack := "Pack" )

  // ------------------------------------------------------------------------ //

  Visual := SceneNode clone appendProto( Inertia ) do (

    isFocused := Nil
    isPopup   := Nil
    model := Nil
    mouse := Nil
    minWidth  := 10
    minHeight := 10
    invalidated := 1
    contextMenu := Nil

    init := method (
      resend()
      self parent  := Nil
      //self reshape := list( Reshape None, Reshape None )
      self reshape := attr( list( Reshape None, Reshape None ) )

      self origin := XPoint clone do (
        .("x") set := method( value, context position set( value, context position y ); _value:( value ) )
        .("y") set := method( value, context position set( context position x, value ); _value:( value ) )
      )
      self extent := XPoint clone do ( x = 90; y = 90
        .("x") set := method( value,
          context resizeChildren( value - context width, 0 )
          _value:( value )
        )
        .("y") set := method( value,
          context resizeChildren( 0, value - context height )
          _value:( value )
        )
      )
      origin .("x") context := origin .("y") context := self
      extent .("x") context := extent .("y") context := self

      self left  := origin ."x"; self top    := origin ."y"
      self width := extent ."x"; self height := extent ."y"
    )

    setModel := method ( model,
      self model = model
      model addListener( self )
      model value = model value
      self
    )
  
    addChild := method ( visual,
      visual parent = self
      addChildNode( visual )
      self
    )

    removeChild := method ( visual,
      visual parent = Nil
      removeChildNode( visual )
      self
    )

    resizeChildren := method ( x, y,
      subnodes foreach ( visual,
        if( visual reshape at(0) == Reshape Move, visual left = visual left + x )
        if( visual reshape at(1) == Reshape Move, visual top = visual top + y )
        if( visual reshape at(0) == Reshape Size, visual resizeBy( x, 0 ) )
        if( visual reshape at(1) == Reshape Size, visual resizeBy( 0, y ) )
        
        visual parentResized( x, y )
      )
    )

    resizeBy := method ( x, y,
      width = minWidth max (width + x)
      height = minHeight max (height + y)
    )

    containsPoint := method ( x, y,
      ( x >= 0 ) and ( x < width ) and ( y >= 0 ) and ( y < height )
    )

    visualAt := method ( x, y,
        subnodes reverseForeach ( visual,
          if( visual containsPoint( x - visual left, y - visual top ) ) then (
            return visual visualAt( x - visual left, y - visual top )
          )
        )
        return self
    )

    sendEvent := method ( event,
      if( (event type == "mouseDown") or (event type == "mouseMove") ) then (
        subnodes reverseForeach ( visual,
          if( visual containsPoint( event x - visual left, event y - visual top ) ) then (
            return visual sendEvent( MouseEvent:( event type, event button, event x - visual left, event y - visual top, event modifiers ) )
          )
        )
      )

      if( event modifiers == 6 ) then (
        if( event type == "mouseDown", self mouse = event )
        if( event type == "mouseMove" and (mouse),
          self left = 0 + (left + (event x - mouse x) / 5) roundDown * 5
          self top = 0 + (top + (event y - mouse y) / 5) roundDown * 5
          invalidate()
        )
        if( event type == "mouseUp", self mouse = Nil )
      ) else (
        self perform( event type, event )
      )

      if( event type != "mouseMove", invalidate() )
      self
    )

    Visual:sendEvent := getSlot("sendEvent")

    invalidate := method (
      self invalidated = 1
      if( parent, parent invalidate(), glutPostRedisplay() )
    )

    screenLeft := method ( left + if( parent, parent screenLeft, 0 ) )
    screenTop  := method ( top + if( parent, parent screenTop, 0 ) )

    drawVisual := method (
      Graphics color( 1.0, 1.0, 1.0 )
      Graphics drawSolidRect( 0, 0, width, height )
    )
  
    drawBorder := method (
      Graphics color( 0.8, 0.8, 0.8 )
      //if( isFocused, Graphics color( 0.65, 0.8, 0.95 ), Graphics color( 0.8, 0.8, 0.8 ) )
      //Graphics drawLineRect( 0, 0, width, height )
      Graphics drawLineRect( 0 - 1, 0 - 1, width + 2, height + 2 )
    )

    updateTexture := Nil

    mouseDown  := Nil
    mouseUp    := Nil
    mouseMove  := Nil
    mouseEnter := Nil
    mouseExit  := Nil

    keyDown    := Nil
    keyUp      := Nil

    valueChanged := Nil
    parentResized := Nil
  )

)

