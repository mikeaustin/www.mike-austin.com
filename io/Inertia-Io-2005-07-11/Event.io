//
// Event.io
//

writeln( "[Event.io]" )

// -------------------------------------------------------------------------- //

Event := Object clone do (

  init := method (
    self type := Nil
    self x    := Nil
    self y    := Nil
    self key  := Nil
    self modifiers := Nil
  )  
 
  set := method ( type, x, y, key, modifiers,
    self type = type
    self x    = x
    self y    = y
    self key  = key
    self modifiers = modifiers
    self
  )

)

MouseEvent: := method ( type, button, x, y, modifiers,
  event := Event clone
  event type := type
  event button := button
  event x := x
  event y := y
  event modifiers := modifiers
  event
)

KeyEvent: := method ( type, key, modifiers,
  Event clone set( type, 0, 0, key, modifiers )
)

NotifyEvent: := method ( type, value,
  event := Event clone 
  event type = type
  event value := value
  event
)


Action := Object clone do (

  target := Nil
  message := Nil
  data := Nil
)

Action: := method ( target, message, data,
  //list( target, message, data )
  action := Action clone
  action target = target
  action message = message
  action data = data
  action
)

