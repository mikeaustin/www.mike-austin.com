module:    inertia-geometry
synopsis:  Core geometry
author:    Mike Austin
copyright: Copyright (C) 2005 Mike L. Austin.  All rights reserved.
license:   MIT/BSD, see LICENCE.txt for details

//
// inertia-geometry.dylan
//

// -------------------------------------------------------------------------- //
// class definitions
// -------------------------------------------------------------------------- //

define class <point> (<object>)
  //slot point-x :: <double-float> = 0.0, init-keyword: x:;
  //slot point-y :: <double-float> = 0.0, init-keyword: y:;
  slot point-x :: <number> = 0.0, init-keyword: x:;
  slot point-y :: <number> = 0.0, init-keyword: y:;
end;

// -------------------------------------------------------------------------- //
// method definitions
// -------------------------------------------------------------------------- //

define method \+ (point :: <point>, other :: <point>) => (result :: <point>)
  make (<point>, x: point.point-x + other.point-x, y: point.point-y + other.point-y);
end;

define method \- (point :: <point>, other :: <point>) => (result :: <point>)
  make (<point>, x: point.point-x - other.point-x, y: point.point-y - other.point-y);
end;

define method \* (point :: <point>, scalar :: <double-float>) => (result :: <point>)
  make (<point>, x: point.point-x * scalar, y: point.point-y * scalar);
end;

define method \/ (point :: <point>, scalar :: <double-float>) => (result :: <point>)
  make (<point>, x: point.point-x / scalar, y: point.point-y / scalar);
end;

define method point-length (point :: <point>)
  sqrt (point.point-x ^ 2 + point.point-y ^ 2);
end;

define method point-values (point :: <point>)
  values (point.point-x, point.point-y);
end;

define method print-object (point :: <point>, stream :: <stream>) => ()
  format (stream, "here\n");
end;

