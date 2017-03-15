//
// Slider.io
//

writeln( "[Slider.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  Slider := Object clone setProto( Visual ) do (

    init := method (
      resend()
      addChild( self knob := Knob clone )
      setModel( RangeModel clone )
    )

    valueChanged := method ( event,
      knob top = 0 + ((event value asNumber - model minValue) / (model maxValue - model minValue)) * (height - knob height)
    )

    drawVisual := method (
      Graphics color( 0.8, 0.8, 0.8 )
      Graphics drawSolidRect( 9, 0, 2, height )
    )

    drawBorder := Nil
    
  )

  // ------------------------------------------------------------------------ //

  Slider Knob := Object clone setProto( Button ) do (

    mouse := Nil

    init := method (
      resend()
      width = 20; height = 10
    )
  
    mouseDown := method ( event, self mouse = event )

    mouseUp := method ( event, self mouse = Nil )

    mouseMove := method ( event,
      if( mouse ) then (
        top := top + (event y - mouse y) min ( parent height - height ) max ( 0 )
        minValue := parent model minValue
        maxValue := parent model maxValue
        parent model value = 0 + ((top / (parent height - height)) * (maxValue - minValue)) + minValue
      )
    )
  
  )

)

