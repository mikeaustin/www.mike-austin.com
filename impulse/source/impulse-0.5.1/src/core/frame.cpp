//
// core/frame.cpp
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "../impulse.h"

namespace impulse {

 //
 // class Frame
 //

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

    string Frame::toString()
    {
        char buffer[256]; snprintf( buffer, 255, "%p", this );

        return buffer;
    }

}

