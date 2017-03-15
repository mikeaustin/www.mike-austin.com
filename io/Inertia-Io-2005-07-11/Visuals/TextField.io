//
// TextField
//

writeln( "[TextField.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  //TextField := Visual clone do (
  TextField := Object clone setProto( Visual ) do (

    init := method (
      resend()
    
      self buffer := Buffer clone
      addChild( self label := Label clone do (
        left = 3; width = 84
        reshape = list( Reshape Size, Reshape Size )
      ))
      label text = buffer
      height = 20
    )

    keyDown := method ( event,
      writeln( "TextField.keyDown: ", event key )
      if( event key == 8 ) then (
        if( buffer length > 0, buffer removeLastByte() )
      ) elseif( event key == 13 ) then (
        if( model, model value = buffer )
        enterDown( event )
      ) else (
        buffer append( event key asCharacter )
      )
    )

    drawVisual := method (
      resend()
     
      Graphics color( 0, 0, 0 )
      Graphics drawSolidRect( label left + Font widthOfString( buffer ), 0 + 2, 1, height - 4 )
    )

    valueChanged := method ( event,
      buffer empty append( event value asString )
    )

    enterDown := Nil

  )

)

