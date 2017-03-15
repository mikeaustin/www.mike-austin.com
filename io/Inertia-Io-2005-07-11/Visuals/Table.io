//
// Table.io
//

writeln( "[Table.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  //Table := Visual clone do (
  Table := Object clone setProto( Visual ) do (

    init := method (
      resend()
      self headerButton := Button clone
      addChild( rows := Rows clone do ( top = 19; height = 71 ) )
    )

    drawVisual := method (
      //glPushMatrix()
      Graphics stack (
        //Font drawString( "Name" )
        headerButton label align = Align Left
        headerButton caption = "Name"
        headerButton width = 100; headerButton height = 18
        headerButton drawVisual()
        headerButton display()
        headerButton drawBorder()

        OpenGL glScaled( 1, -1, 1 )
        Graphics translate( 4.0, -14.0, 0 )
        Graphics color( 0.25, 0.25, 0.25 )

        glTranslated( 100, 0, 0 )
        model columns foreach ( i, column,
          if( column type == "String",
            Font drawString( column name )
            glTranslated( column width, 0, 0 )
          )
          if( (column type == "Number") or (column type == "Date"),
            glTranslated( column width - Font widthOfString( column name ), 0, 0 )
            Font drawString( column name )
            glTranslated( Font widthOfString( column name ), 0, 0 )
          )
          glTranslated( 10, 0, 0 )
        )
      //glPopMatrix()
      )
    )

    sendEvent := method ( event,
      if( event y <= 20, headerButton sendEvent( event ), resend() )
    )

  )

  //Rows := Visual clone do (
  Rows := Object clone setProto( Visual ) do (

    selectIndex := 0

    init := method (
      resend()
      reshape = list( Reshape Size, Reshape Size )
    )

    drawVisual := method (
      //glPushMatrix()
      Graphics stack (
        //glEnable( GL_SCISSOR_TEST )
        //glScissor( screenLeft, 768 - screenTop - height, width, height )
        resend()

        OpenGL glScaled( 1, -1, 1 )
        Graphics color( 0.25, 0.25, 0.25 )

        glTranslated( 3.0, -14, 0 )

        parent model items foreach ( j, item,
          //glPushMatrix()
          Graphics stack (
            if( j == selectIndex ) then (
              Graphics color( 0.6, 0.8, 1.0 )
              Graphics drawSolidRect( -3.0, -4, width, 18 )
            )
            Graphics color( 0.25, 0.25, 0.25 )
            //Font drawString( item name )
            Font drawString( item name )
            glTranslated( 100, 0, 0 )
            //item fields foreach( i, field,
            i := 0
            ///item = item values // have sqlite return values
            //item foreach( col, field,
            parent model columns foreach( i, column,
              if( column type == "String",
                Font drawString( item fields at(i) asString( parent model columns at(i) format ) )
                glTranslated( parent model columns at(i) width, 0, 0 )
              )
//              if( (column type == "Number") or (item at(i) type == "Date"),
  //              string := item at(i) asString( parent model columns at(i) format )
    //            glTranslated( parent model columns at(i) width - Font widthOfString( string ), 0, 0 )
      //          Font drawString( string )
        //        glTranslated( Font widthOfString( string ), 0, 0 )
          //    )
              glTranslated( 10, 0, 0 )
            )
          //glPopMatrix()
          )
          glTranslated( 0, -18, 0 )
        )

        //glDisable( GL_SCISSOR_TEST )
        //glPopMatrix()
      )
    )

    drawBorder := Nil

    mouseDown := method ( event,
      self selectIndex = (((event y / 18) - 0.5) roundDown)
      writeln( event y, " ", selectIndex )
      invalidate()
    )

  )

)

