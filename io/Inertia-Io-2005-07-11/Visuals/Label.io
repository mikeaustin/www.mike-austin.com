//
// Label.io
//

writeln( "[Label.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  Align := Object clone do ( Left := 0; Center := 1; Right := 2 )

  //Label := Visual clone do (
  Label := Object clone setProto( Visual ) do (

    Font open( launchPath appendPath( "Fonts/Free/Sans/Normal.ttf" ) )
    boldFont := Font clone open( launchPath appendPath( "Fonts/Free/Sans/Bold.ttf" ) )
  
    init := method (
      resend()
      
      Font setPixelSize( 12 )
      boldFont setPixelSize( 12 )
      Font setPixelSize( 13 )
      boldFont setPixelSize( 13 )
      self font := Font
      Font drawString( "" )
      boldFont drawString( "" )
      
      self align    := Align Left
      self text     := attr( "" ) do (
        set := method ( value, if( context autoSize, context resize() ); _value:( value ) )
      )
      
      self autoSize := Nil
      //height = Font pixelHeight + 5
    )

    resize := method (
      width := font widthOfString( text )
    )
  
    drawVisual := method (
      textWidth  := font widthOfString( text )
      textHeight := font pixelHeight / 2 - 1

      Graphics stack (
        if( align == Align Left ) then (
          glTranslated( 0.0, ((height / 2) roundUp) + textHeight, 0 )
        )
        if( align == Align Center ) then (
          glTranslated( ((width / 2) roundUp) - (textWidth / 2) roundUp,
                        ((height / 2) roundUp) + textHeight, 0 )
        )
        if( align == Align Right ) then (
          glTranslated( width - textWidth,
                        ((height / 2) roundUp) + textHeight, 0 )
        )

        OpenGL glScaled( 1, -1, 1 )
        Graphics color( 0.25, 0.25, 0.25 )
        font drawString( text )
        glGetError
      )
    )

    drawBorder := Nil

    containsPoint := Nil
  )

)

