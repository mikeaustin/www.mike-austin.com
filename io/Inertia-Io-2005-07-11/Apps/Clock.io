//
// Clock.io
//

Clock := Object clone setProto( Visual ) do (

  Pi    := Number constants pi
  time  := Nil
  mouse := Nil

  start := method (
    while( 1,
      self time = Date clone now
      invalidate()
      wait( 1.0 - (time second - time second roundDown) )
    )
  )
  
  drawVisual := method (
    size := width min (height) - 10

    //Graphics color( 1, 1, 1 )
    //Graphics drawSolidRect( 0, 0, width, height )
    
    Graphics stack (
    Graphics translate( width / 2, height / 2 )
    Graphics color( 1, 1, 1 )
    Graphics vertex( width / 2, height / 2 )

    Graphics color( .25, .25, .25 )
    Graphics begin( GL_LINES,
      for( i, 0, 360, 30,
        Graphics vertex( (((i - 90) * (Pi / 180)) cos * (size / 2 - 3)),
                         (((i - 90) * (Pi / 180)) sin * (size / 2 - 3)) );
        Graphics vertex( (((i - 90) * (Pi / 180)) cos * (size / 2)),
                         (((i - 90) * (Pi / 180)) sin * (size / 2)) );
      )
    )

    glLineWidth( 3 )
    seconds := ((time hour % 12 * 3600) + (time minute * 60) + (time second))
    Graphics begin( GL_LINES,
      Graphics vertex( 0, 0 )
      Graphics vertex( ((((seconds / 3600 * 30) - 90) * (Pi / 180)) cos * (size / 3)),
                       ((((seconds / 3600 * 30) - 90) * (Pi / 180)) sin * (size / 3)) );
      Graphics vertex( 0, 0 )
      Graphics vertex( (((seconds / 60 * 6 - 90) * (Pi / 180)) cos * (size / 2 - 5)),
                       (((seconds / 60 * 6 - 90) * (Pi / 180)) sin * (size / 2 - 5)) );
    )
    glLineWidth( 1 )
    Graphics begin( GL_LINES,
      Graphics vertex( 0, 0 )
      Graphics vertex( (((time second * 6 - 90) * (Pi / 180)) cos * (size / 2 - 5)),
                       (((time second * 6 - 90) * (Pi / 180)) sin * (size / 2 - 5)) );
    )
    )
  )

)

Object clone setProto( Window ) do (

  init := method (
    resend()
    caption = "Clock"
    minHeight = 120
    width = 100; height = 100 + 20; sizeChanged = 1
    addChild( clock := Clock clone do (
      width = 100; height = 100
      reshape = list( Reshape Size, Reshape Size )
    ))
    clock @@start
  )

)

