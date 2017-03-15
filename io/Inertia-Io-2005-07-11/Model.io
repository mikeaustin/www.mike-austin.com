//
// Model.io
//

writeln( "[Model.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  Model := Object clone do (

    init := method (
      self listeners := List clone

      self value := attr( Nil ) do (
        set := method ( value,
          _value:( value )
          context listeners foreach( object, object sendEvent( NotifyEvent:( "valueChanged", _value ) ) )
        )
      )
    )

    addListener := method ( object,
      listeners add( object )
    )

    addAction := method (
      Nil
    )

  )

  RangeModel := Model clone do (
  
    minValue := 3
    maxValue := 9
    
    init := method (
      resend()

      self value := attr( 0 ) do (
        set := method ( value,
          _value:( value asNumber roundDown min ( context maxValue ) max ( context minValue ) )
          context listeners foreach( object, object sendEvent( NotifyEvent:( "valueChanged", _value ) ) )
        )
      )
    )

  )

  NumberModel := Model clone do (

    init := method (
      resend()
      self value := attr( 0 ) do (
        set := method ( value,
          _value:( value asNumber )
          context listeners foreach( object, object sendEvent( NotifyEvent:( "valueChanged", _value ) ) )
        )
      )
    )

  )

  StringModel := Model clone do (
  
    init := method (
      resend()
      
      self buffer := Buffer clone
    )
  
  )
  
)

