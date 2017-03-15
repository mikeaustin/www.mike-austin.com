//
// core/frame.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_FRAME_H_
#define _IMPULSE_FRAME_H_

#include <string>
#include <map>

#include "../impulse.h"

namespace impulse {

 //
 // class Frame
 //

 ///
 /// A Frame is a container for storing Symbol to Value references.  It includes methods for
 /// evaluating, sending messages, proto lookup, inspection and garbage collection.
 ///

    class Frame {

     public:

        //void* operator new( size_t size );

        Frame( Frame* proto = NULL );
        virtual ~Frame();

        Value getSlot( Symbol& symbol );
        Value setSlot( Symbol& symbol, Value value );

        virtual Value eval( Array& args, Value self );

        Value send( Symbol& selector, Array& args );
        Value send( Symbol& selector, Array& args, Value self );

        virtual void initSlots() { }

        map<Symbol*, Value>& slots() { return _slots; }
        Frame*& proto() { return _proto; }

        virtual string inspect();
        virtual string toString();

     private:

        map<Symbol*, Value> _slots;
        Frame*              _proto;
        unsigned short      _refCount;

        friend class Value;

    };

}

#endif

