//
// LoginPanel
//

writeln( "[LoginPanel.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  LoginPanel := Object clone setProto( Window ) do (

    init := method (
      writeln( "> here" )
      resend()
      writeln( "< here" )
      
      addChild( Label clone do (
        text = "Username:"
        left = 5; top = 5; width = 65; height = 20
        align = Align Right
      ))
      addChild( Label clone do (
        text = "Password:"
        left = 5; top = 30; width = 65; height = 20
        align = Align Right
      ))
      addChild( self username := TextField clone do (
        left = 75; top = 5; width = 150; height = 20
      ))
      addChild( self password := TextField clone do (
        left = 75; top = 30; width = 150; height = 20
      ))
      addChild( Button clone do (
        caption = "Canel"
        left = 5; top = 60; width = 75; height = 20
      ))
      addChild( Button clone do (
        caption = "Login"
        left = 150; top = 60; width = 75; height = 20
      ))
      
      width = 230; height = 105
      focusedVisual = username
    )
  
  )
  
)

