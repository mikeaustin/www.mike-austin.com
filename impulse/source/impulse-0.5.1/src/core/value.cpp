//
// core/value.cpp
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "../impulse.h"

namespace impulse {

 //
 // class Value
 //

    string Value::inspect()
    {
        if (getFrame() == _nil_.getFrame())
        {
            return "[Nil]";
        }
        else if (getFrame() == _LitNum_.getFrame())
        {
            char buffer[256]; snprintf( buffer, 255, "%lf", getFloat() );

            return buffer;
        }
        else if (getFrame() == _LitPoint_.getFrame())
        {
            char buffer[256]; snprintf( buffer, 255, "%f @ %f", getX(), getY() );

            return buffer;
        }
        else
        {
            return getFrame()->inspect();
        }
    }

    string Value::toString()
    {
        if (getFrame() == _nil_.getFrame())
        {
            return "nil";
        }
        else if (getFrame() == _LitNum_.getFrame())
        {
            char buffer[256]; snprintf( buffer, 255, "%lf", getFloat() );

            return buffer;
        }
        else
        {
            return getFrame()->toString();
        }
    }

}

