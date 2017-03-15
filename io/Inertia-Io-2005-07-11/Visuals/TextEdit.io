//
// TextEdit.io
//

writeln( "[TextEdit.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  TextEdit := Object clone setProto( Visual ) do (
  
    init := method (
      resend()
      
      self buffer := Buffer clone
      self lines := 0
      self textTop := 0
    )

    drawVisual := method (
      resend()
      
      textWidth  := ((Font widthOfString( buffer ) / 2) roundUp)
      textHeight := 15

      lastFind := 0
      lines := 0

      //glPushMatrix()
      Graphics stack (
        //if( self lines * 15 > height, glTranslated( 0, (self lines * -15) + height - 4, 0 ) )

        glTranslated( 3.0, textHeight, 0 )
        OpenGL glScaled( 1, -1, 1 )
        Graphics color( 0.25, 0.25, 0.25 )

        i := 0
        i := textTop
        textWidth := 0

        while( i < buffer length,
          //writeln( i, " ", lastFind, " ", buffer length )
          lastFind = ( ( buffer find( " ", i ) or ( 65000 ) ) min ( buffer find( "\n", i ) or ( 65000 ) ) min ( buffer length ) )

          string := buffer fromTo( i, lastFind + 1 )

          if( (textWidth + Font widthOfString( string ) > width - 10) ) then (
            glTranslated( -textWidth, -15, 0 )
            textWidth = 0
            lines = lines + 1
            if( self lines * 15 > height, self textTop = textTop + 1 )
          )

          textWidth = textWidth + Font widthOfString( string )

          Font drawString( string )
          glTranslated( Font widthOfString( string ), 0, 0 )

          if( buffer at( lastFind ) == 10 ) then (
            glTranslated( -textWidth, -15, 0 )
            textWidth = 0
            lines = lines + 1
            if( self lines * 15 > height, self textTop = textTop + 1 )
          )

          i = lastFind + 1
        )
      //glPopMatrix()
      )
      
      self lines = lines
    )

    append := method ( string,
      buffer append( string )
      writeln( "append: ", buffer length )
      invalidate()
      invalidate()
      invalidate()
    )

    scrollToLastPage := method (
      Nil
    )    
    
  )
  
)

/*
*/
