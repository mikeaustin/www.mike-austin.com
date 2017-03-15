//
// protos/object.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_OBJECT_H_
#define _IMPULSE_OBJECT_H_

#include <cmath>
#include <typeinfo>

#include "../impulse.h"

namespace impulse {

 //
 // class Object
 //

 ///
 /// Object is the root of the proto hierarchy, which provides basic functions such as setting and
 /// getting slots.  The term "an Object" refers to a Frame which has an Object in its proto chain,
 /// else it's only just a "Frame".
 ///

    class Object : public Frame {

     public:

		Object() { }

        void initSlots()
        {
            setSlot( Symbol::at("test"), new Method<Object>( "test", &Object::_test ) );
            setSlot( Symbol::at("set-slot"), new Method<Object>( "set-slot", &Object::_setSlot_ ) );
        }

        string inspect() { return "[Object]"; }

     //protected:

        Value _test( Array& args, Value self )
        {
            BEG( "Object::_test()" );

            Value result = self.setSlot( Symbol::at("foo"), 15.0 );

            END( "" );

            return result;
        }

        Value _setSlot_( Array& args, Value self )
        {
            BEG( "Object::_setSlot()" );

            cout << ">>> " << args.at(1).inspect() << endl;
            Value result = self.setSlot( *args.at(0).get<Symbol>(), args.at(1) );
            
            END( result.inspect() );
            
            return result;
        }

    };

}

#endif
