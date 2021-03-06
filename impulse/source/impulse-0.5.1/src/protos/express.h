//
// protos/express.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_EXPRESS_H_
#define _IMPULSE_EXPRESS_H_

#include "../impulse.h"

namespace impulse {

 //
 // class Express
 //
 
 ///
 /// An expression is a sequence of Values, which when evaluated calls eval() on each Value with
 /// the previous result as the receiver.
 ///

    class Express : public Frame {

     public:

     // Constructors

		Express() { }
		Express( Express& parent ) : _parent( &parent ) { }

     // Runtime overrides

        Value eval( Array& args, Value self );

        string inspect() { return "[Express]"; }

        Value invoke( Array& args, Value self );

        void push( Value value ) { _code2.push( value ); }
        void clear() { _code2.clear(); }

        Express& parent() { return *_parent; }

     //protected:
     
        Value _create( Array& args, Value self )
        {
            return 10;
        }

     private:

        Array    _code2;
        Express* _parent;

    };

 //
 // class Express
 //

    inline Value Express::eval( Array& args, Value self )
    {
        Value result = -1.0;

        BEG( "Express::eval()" );

        result = invoke( args, self );

        END( "" );

        return result;
    }


    inline Value Express::invoke( Array& args, Value self )
    {
        Value* ip = _code2.data();
        Value* end = _code2.data() + _code2.size();
        Value  value = self;

        Array margs( self );

        while (ip < end)
        {
            value = ip++->eval( margs, value );
        }

        return value;
    }

}

#endif

