//
// protos/float.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_FLOAT_H_
#define _IMPULSE_FLOAT_H_

#include <cmath>
#include <limits>

#include "../impulse.h"
#include "range.h"

namespace impulse {

 //
 // class Float
 //

 ///
 /// Float is the core class for numbers.  It contains methods for arithmetic, trigenometry and
 /// other common numerical functions.
 ///

    class Float : public Frame {

     public:

        Float( Frame* proto = _Float_.getFrame() ) : Frame( proto ) { }
		
        string inspect() { return "[Float]"; }

        double abs( double value ) { return value < 0 ? value * -1.0 : value; }

     private:

        friend class FloatTest;

    };

    class FloatProto : public Float {
    
     public:

        FloatProto() : Float( _Object_.getFrame() ) { }

        string inspect() { return "[FloatProto]"; }
     
        void initSlots()
        {
            //setSlot( Symbol::at( "+" ), new Method<Float>( "+", &Float::_add_ ) );
            setSlot( Symbol::at( "+" ), new Method<FloatProto>( &FloatProto::_add_, _Float_.getFrame() ) );
            setSlot( Symbol::at( "-" ), new Method<FloatProto>( &FloatProto::_sub_, _Float_.getFrame() ) );
            setSlot( Symbol::at( "*" ), new Method<FloatProto>( &FloatProto::_mul_, _Float_.getFrame() ) );
            setSlot( Symbol::at( "/" ), new Method<FloatProto>( &FloatProto::_div_, _Float_.getFrame() ) );

            setSlot( Symbol::at( "sin" ), new Method<FloatProto>( &FloatProto::_sin ) );
            setSlot( Symbol::at( "cos" ), new Method<FloatProto>( &FloatProto::_cos ) );
            setSlot( Symbol::at( "pow" ), new Method<FloatProto>( &FloatProto::_pow_ ) );
            setSlot( Symbol::at( "abs" ), new Method<FloatProto>( &FloatProto::_abs ) );

            setSlot( Symbol::at( ".." ), new Method<FloatProto>( &FloatProto::_range_ ) );
            setSlot( Symbol::at( "@" ), new Method<FloatProto>( &FloatProto::_point_ ) );
        }
        
        Value _add_( Array& args, Value self )     { return self.getFloat() + args.at( 0 ).getFloat(); }
        Value _sub_( Array& args, Value self )     { return self.getFloat() - args.at( 0 ).getFloat(); }
        Value _mul_( Array& args, Value self )     { return self.getFloat() * args.at( 0 ).getFloat(); }
        Value _div_( Array& args, Value self )     { return self.getFloat() / args.at( 0 ).getFloat(); }
        Value _add_nil( Array& args, Value self )  { cout << "!!!" << endl; return self.getFloat() + args.at( 0 ).getFloat(); }

        Value _sin( Array& args, Value self )   { return ::sin( self.getFloat() ); }
        Value _cos( Array& args, Value self )   { return ::cos( self.getFloat() ); }
        Value _pow_( Array& args, Value self )  { return ::pow( self.getFloat(), args.at( 0 ).getFloat() ); }
        Value _abs( Array& args, Value self )   { return abs( self.getFloat() ); }

        Value _range_( Array& args, Value self )   { return new Range( (int) self.getFloat(), (int) args.at( 0 ).getFloat() ); }
        Value _point_( Array& args, Value self )   { return Value( self.getFloat(), args.at( 0 ).getFloat() ); }
     
    };

}

#endif

