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

        string inspect() { return "[Object]"; }

    };

    class ObjectProto : public Object {
    
        void initSlots()
        {
            setSlot( Symbol::at( "self" ), new Method<ObjectProto>( &ObjectProto::self ) );
            setSlot( Symbol::at( "proto" ), new Method<ObjectProto>( &ObjectProto::proto ) );
            setSlot( Symbol::at( "slots" ), new Method<ObjectProto>( &ObjectProto::slotNames ) );
            setSlot( Symbol::at( "all-slots" ), new Method<ObjectProto>( &ObjectProto::allSlotNames ) );
            setSlot( Symbol::at( "set-slot" ), new Method<ObjectProto>( &ObjectProto::setSlot_ ) );
            setSlot( Symbol::at( "," ), new Method<ObjectProto>( &ObjectProto::_array_ ) );
        }

        string inspect() { return "[ObjectProto]"; }

        Value _array_( Array& args, Value self )   { return new Array( self, args.at( 0 ) ); }

        Value self( Array& args, Value self )
        {
            return self;
        }

        Value proto( Array& args, Value self )
        {
            if (self.getFrame()->proto())
                return self.getFrame()->proto();
            else
                return _nil_;
        }
        
        Value slotNames( Array& args, Value self )
        {
            //Array& names = *new Array;
            Frame& frame = *self.get<Frame>();

            map<Symbol*, Value>::iterator i;
            for (i = frame.slots().begin(); i != frame.slots().end(); ++i)
            {
                //names.push( i->first );
                cout << i->first->inspect() << " = " << i->second.inspect() << endl;
            }

            //return &names;
            return _nil_;
        }

        Value allSlotNames( Array& args, Value self )
        {
            //Array& names = *new Array;
            Frame* frame = self.get<Frame>();

            while (frame)
            {
                cout << frame->inspect() << endl;
                
                map<Symbol*, Value>::iterator i;
                for (i = frame->slots().begin(); i != frame->slots().end(); ++i)
                {
                    //names.push( i->first );
                    cout << "  " << i->first->inspect() << " = " << i->second.inspect() << endl;
                }
                
                frame = frame->proto();
            }

                //return &names;
                return _nil_;
        }

        Value setSlot_( Array& args, Value self )
        {
            BEG( "Object::_setSlot()" );

            cout << ">>> " << args.at( 1 ).inspect() << endl;
            Value result = self.setSlot( *args.at( 0 ).get<Symbol>(), args.at( 1 ) );
            
            END( result.inspect() );
            
            return result;
        }
    
    };

}

#endif

