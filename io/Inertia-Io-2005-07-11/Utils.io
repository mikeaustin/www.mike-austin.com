//
// Utils.io
//

writeln( "[Utils.io]" )

// -------------------------------------------------------------------------- //

import := method ( filename,
  //if( importedFiles contains( file ) == Nil ) then (
  //  importedFiles add( file )
    Importer turnOff
    self doFile( launchPath appendPath( filename ) )
  //)
)

Object using := method ( namespace, self appendProto( namespace ) )

Object setSlot( ".", getSlot("getSlot") )

Object do (
  _updateSlot := getSlot("updateSlot")
  updateSlot := method ( name, value,
    if( self getSlot(name) type == "Attr" ) then (
      //writeln( "#" )
      //self getSlot(name) _updateSlot("_value", self getSlot(name) set( getSlot("value") ) )
      self getSlot(name) set( getSlot("value") )
    ) else (
      self _updateSlot( name, getSlot("value") )
    )
  )
)

Object attr := method ( value, context,
  m := method (
    //write( "@" )
    getSlot("thisBlock") get()
  )
  getSlot("m") _value := getSlot("value")
  getSlot("m") context := sender self
  //getSlot("m") context := context
  getSlot("m") do (
    type  := "Attr"
    get := method ( return _value )
    set := method ( value, _value:( value ) )
    //set := method ( value, writeln(context); _value:( value ) )
    _value: := method ( value, _updateSlot( "_value", getSlot("value") ) )
  )
  getSlot("m")
)

Object do2 := method (
  self container := sender self
  self doMessage( thisMessage argAt(0) )
  self
)

XPoint := Object clone do (
  x := 0
  y := 0
  
  init := method (
    self x := attr( 0 )
    self y := attr( 0 )
  )

  print := method (
    writeln( "Point( ", x, ", ", y, " )" )
  )
)

point := method ( x, y,
  //Point clone set( x, y, 0 )
  Point clone do ( x = 0; y = 0 )
)

