//
// core/value.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_VALUE_H_
#define _IMPULSE_VALUE_H_

#include <string>

#include "../impulse.h"

namespace impulse {

 //
 // class Value
 //

 ///
 /// A Value is a holder for things such as a number or a pointer to a Frame.  It acts as a "smart
 /// pointer", decreasing the chances of null pointer access.  It it used extentively for passing
 /// values to functions and returning values.
 ///

    class Value {

     public:

        Value();
        Value( double value );
        Value( string value );
        Value( Frame* value );
        Value( float x, float y );

        Value getSlot( Symbol& symbol );
        Value setSlot( Symbol& symbol, Value value );

        Value eval( Array& args, Value self );
        Value send( Symbol& selector, Array& args );

        string inspect();
        string toString();

        Frame* getFrame() { return _frame; }
        double getFloat() { return _float; }
        float getX() { return _x; }
        float getY() { return _y; }
        template <typename T>
        T* get() { return dynamic_cast<T*>( getFrame() ); }

        void incrRef();
        void decrRef();

     private:

        Frame* _frame;
        union {
            double  _float;
            struct {
                float _x; float _y;
            };
        };

    };

 //
 // class val
 //
 // val is a subclass of Value, which supports standard math operations and provides convenience
 // functions.  It can be thought of as an "any type" or "variant" that can store any type.
 //

    class val : public Value {
    
     public:
     
        val( val const& value );
        val( Frame* value );
        
        val& operator =( val const& value );
        val& operator =( Frame* frame );

    };

}

#endif

