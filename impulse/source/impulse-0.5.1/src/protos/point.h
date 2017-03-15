//
// protos/point.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_POINT_H_
#define _IMPULSE_POINT_H_

#include <cstdlib>

#include "../impulse.h"

namespace impulse {

 //
 // class Point
 //

 ///
 /// A point contains two floats, x and y.  A point is stored inline inside Value, so it's fast and
 /// does not use dynamic allocation.
 ///

    class Point : public Frame {

     public:

        Point( Frame* proto = _Point_.getFrame() ) : Frame( proto ) { }

        string inspect() { return "[Point]"; }

    };

 //
 // class PointProto
 //

    class PointProto : public Point {
    
     public:

        PointProto() : Point( _Object_.getFrame() ) { }
     
		void initSlots()
        {
            setSlot( Symbol::at( "+" ), new Method<PointProto>( &PointProto::_add_, _Point_.getFrame() ) );
            setSlot( Symbol::at( "-" ), new Method<PointProto>( &PointProto::_sub_, _Point_.getFrame() ) );
        }

        string inspect() { return "[PointProto]"; }

     protected:

        Value _add_( Array& args, Value self )
         { return Value( self.getX() + args.at( 0 ).getX(), self.getY() + args.at( 0 ).getY() ); }

        Value _sub_( Array& args, Value self )
         { return Value( self.getX() - args.at( 0 ).getX(), self.getY() - args.at( 0 ).getY() ); }

    };

}

#endif

