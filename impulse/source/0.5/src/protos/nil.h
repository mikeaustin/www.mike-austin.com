//
// protos/nil.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_NIL_H_
#define _IMPULSE_NIL_H_

#include "../impulse.h"

namespace impulse {

 //
 // class Nil
 //

    class Nil : public Frame {

     public:

		Nil() { }

        string inspect() { return "[Nil]"; }

     protected:

     private:

    };

}

#endif
