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

		Float() { }

        void initSlots()
        {
            //setSlot( Symbol::at("+"), new Method<Float>( "+", &Float::_add_ ) );
            setSlot( Symbol::at("+"), new Method<Float>( "+", &Float::_add_, _LitNum_.getFrame() ) );
            setSlot( Symbol::at("-"), new Method<Float>( "-", &Float::_sub_, _LitNum_.getFrame() ) );
            setSlot( Symbol::at("*"), new Method<Float>( "*", &Float::_mul_, _LitNum_.getFrame() ) );
            setSlot( Symbol::at("/"), new Method<Float>( "/", &Float::_div_, _LitNum_.getFrame() ) );

            setSlot( Symbol::at("sin"), new Method<Float>( "sin", &Float::_sin ) );
            setSlot( Symbol::at("cos"), new Method<Float>( "cos", &Float::_cos ) );
            setSlot( Symbol::at("pow"), new Method<Float>( "pow", &Float::_pow_ ) );
            setSlot( Symbol::at("abs"), new Method<Float>( "abs", &Float::_abs ) );
        }

        string inspect() { return "[Float]"; }

        double abs( double value );

     protected:

        Value _add_( Array& args, Value self )     { return self.getFloat() + args.at(0).getFloat(); }
        Value _sub_( Array& args, Value self )     { return self.getFloat() - args.at(0).getFloat(); }
        Value _mul_( Array& args, Value self )     { return self.getFloat() * args.at(0).getFloat(); }
        Value _div_( Array& args, Value self )     { return self.getFloat() / args.at(0).getFloat(); }
        Value _add_nil( Array& args, Value self )  { cout << "!!!" << endl; return self.getFloat() + args.at(0).getFloat(); }

        Value _sin( Array& args, Value self )   { return ::sin( self.getFloat() ); }
        Value _cos( Array& args, Value self )   { return ::cos( self.getFloat() ); }
        Value _pow_( Array& args, Value self )  { return ::pow( self.getFloat(), args.at(0).getFloat() ); }
        Value _abs( Array& args, Value self )   { return abs( self.getFloat() ); }

     private:

        friend class FloatTest;

    };

 //
 // class Float
 //

    double Float::abs( double value )
    {
        BEG( "Float::abs( value = " << value << " )" );

        double result = value < 0 ? value * -1.0 : value;

        END( result );

        return result;
    }

}

#endif
