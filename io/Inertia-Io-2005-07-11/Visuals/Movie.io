//
// Player.io
//

writeln( "[Movie.io]" )

// -------------------------------------------------------------------------- //

Inertia do (

  Movie := Object clone setProto( Visual ) do (

    init := method (
      resend()
      
      self movie := Movie clone open( launchPath appendPath( "knot.mpg" ) )
      movie setOutputWidth( width ) setOutputHeight( height )
    )

    start := method (
      writeln( "Movie.start()" )
      while( 1,
        movie nextFrame()
        invalidate()
        if( movie isAtEnd, movie rewind )
        wait( 0.0333333 )
      )
    )

    drawVisual := method (
      glTranslated( 0, height, 0 )
      movie draw()
      glTranslated( 0, -height, 0 )
    )

    parentResized := method ( event,
      movie setOutputWidth( width ) setOutputHeight( height )
    )    
    
  )
  
)

