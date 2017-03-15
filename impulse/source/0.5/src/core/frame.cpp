//
// core/frame.cpp
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "../impulse.h"
#include "../protos/array.h"
#include "../protos/symbol.h"

namespace impulse {

 //
 // class Frame
 //

    Frame::~Frame()
    {
        map<Symbol*, Value>::iterator i;
        for (i = slots().begin(); i != slots().end(); ++i)
        {
            i->second.decrRef();
        }
    }


    Value Frame::eval( Array& args, Value self )
    {
        BEG( "Frame::eval()" );

        END( "" );

        return this;
    }


    string Frame::inspect()
    {
        char buffer[256]; snprintf( buffer, 255, "%p", this );

        return buffer;
    }

}
