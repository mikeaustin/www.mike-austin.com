//
// protos/expression.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_EXPRESSION_H_
#define _IMPULSE_EXPRESSION_H_

#include "array.h"

namespace impulse {

 //
 // class Block
 //
 // A block is a lexically scoped, deferred execution block of code, or closure.  A block takes
 // the current execution context and arguments for the block as arguments.
 //

 //
 // class Expression
 //

    class Expression : public Frame {

     public:

     // Constructors

		Expression( Value* code ) : _code( code ) { }
		Expression( Array& code ) : _code2( &code ) { }

     // Runtime overrides

        Value eval( Array& args, Value self );

        string inspect() { return "[Expression]"; }

        Value invoke( Array& args, Value self );

     private:

		Value* _code;
        Array* _code2;

    };

 //
 // class Expression
 //

    Value Expression::eval( Array& args, Value self )
    {
        Value result = -1.0;

        BEG( "Expression::eval()" );

        result = invoke( args, self );

        END( "" );

        return result;
    }


    Value Expression::invoke( Array& args, Value self )
    {
        Value* ip = _code2->data();
        Value* end = _code2->data() + _code2->size();
        Value  value = self;

        while (ip < end)
        {
            value = ip++->eval( args, value );
        }

        return value;
    }

}

#endif
