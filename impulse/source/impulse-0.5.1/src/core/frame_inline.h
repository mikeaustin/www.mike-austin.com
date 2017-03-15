//
// core/frame_inline.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_FRAME_INLINE_
#define _IMPULSE_FRAME_INLINE_

#include "../protos/array.h"

namespace impulse {

 //
 // class Frame
 //
/*
    inline void* Frame::operator new( size_t size )
    {
        Frame* frame = (Frame*) ::operator new( size );

        //cout << "Frame::operator new()" << endl;
        
        return frame;
    }
*/
    inline Frame::Frame( Frame* proto ) : _proto( proto ), _refCount( 0 ) { }

    inline Frame::~Frame() { }
/*    {
        TRACE( "Frame::~Frame()" ); // Array args is a frame!

        map<Symbol*, Value>::iterator i;
        for (i = slots().begin(); i != slots().end(); ++i)
        {
            i->second.decrRef();
        }
    }*/


    inline Value Frame::getSlot( Symbol& symbol )
    {
        if (slots().find( &symbol ) != slots().end())
            return slots()[&symbol];
        else
            return _nil_;
    }

    inline Value Frame::setSlot( Symbol& symbol, Value value )
    {
        if (slots().find( &symbol ) != slots().end())
            slots()[&symbol].decrRef();

        value.incrRef();

        return slots()[&symbol] = value;
    }


    inline Value Frame::send( Symbol& selector, Array& args )
    {
        return send( selector, args, this );
    }

    inline Value Frame::send( Symbol& selector, Array& args, Value self )
    {
        BEG( "Frame::send( sel = " << selector.getName().c_str() << ", self = " << self.inspect() << " )" );

        Value result = -1;

        Value method = getSlot( selector );

        if (method.getFrame() != _nil_.getFrame())
        {
            Array margs( this, &args );

            try
            {
                result = method.eval( margs, self );
            }
            catch( string error )
            {
                cout << "** " << inspect() << "::" << selector.getName() << ": " << error << endl;
            }
        }
        else if (proto() != NULL)
        {
            result = proto()->send( selector, args, self );
        }
        else
        {
            cout << "*** " << self.inspect() << " Slot not found: " << selector.getName() << endl;
        }

        END( result.inspect() );

        return result;
    }

}

#endif

