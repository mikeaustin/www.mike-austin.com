//
// core/value_inline.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_VALUE_INLINE_
#define _IMPULSE_VALUE_INLINE_

#include "../protos/symbol.h"
#include "../protos/string.h"
#include "../protos/array.h"

namespace impulse {

 //
 // class Value
 //

    inline Value::Value()                   : _frame( _nil_.getFrame() ), _float( -1 ) { }
    inline Value::Value( double value )     : _frame( _LitNum_.getFrame() ), _float( value ) { }
    inline Value::Value( string value )     : _frame( new String( value ) ), _float( -2 ) { }
    inline Value::Value( Frame* frame )     : _frame( frame ), _float( -0 ) { }
    inline Value::Value( float x, float y ) : _frame( _LitPoint_.getFrame() ), _x( x ), _y( y ) { }

    inline Value Value::getSlot( Symbol& symbol )
    {
        Value result = getFrame()->getSlot( symbol );

        return result;
    }

    inline Value Value::setSlot( Symbol& symbol, Value value )
    {
        Value result = getFrame()->setSlot( symbol, value );

        return result;
    }


    inline Value Value::eval( Array& args, Value self )
    {
        BEG( "Value::eval( args, self = " << self.inspect() << " )" );

        Value result;

        if (getFrame() == _LitNum_.getFrame())
        {
            result = *this;
        }
        else
        {
            result = getFrame()->eval( args, self );
        }

        END( result.inspect() );

        return result;
    }


    inline Value Value::send( Symbol& selector, Array& args )
    {
        BEG( "Value::send( args, sel = " << selector.getName() << " )" );

        Value result = getFrame()->send( selector, args, *this );

        END( result.inspect() );

        return result;
    }


    inline void Value::incrRef()
    {
        getFrame()->_refCount++;
    }

    inline void Value::decrRef()
    {
        TRACE( "Value::decrRef() " << inspect() << " " << getFrame()->_refCount );

        if (--getFrame()->_refCount == 0)
        {
            cout << "\x1b[33mdelete\x1b[0m " << inspect() << endl;

            //delete getFrame();
        }
    }

}

#endif

