//
// impulse.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_H_
#define _IMPULSE_H_

#define DEBUG

#ifdef DEBUG
 #define BEG( string ) trace << &(spaces[60 - indent]) << "> " << string << endl; indent += 3;
 #define END( string ) indent -= 3; trace << &(spaces[60 - indent]) << "< " << string << endl
 #define TRACE( string ) trace << &(spaces[60 - indent]) << string << endl;
#else
 #define BEG( string )
 #define END( string )
 #define TRACE( string )
#endif


#define ASSERT( code ) cout << ((code) ?	\
 "\x1b[32mpass\x1b[0m" : "\x1b[31mfail\x1b[0m") << " " << #code << endl
#define OUTPUT( string ) cout << string << endl

#include <map>

using namespace std;

namespace impulse {

    class UnitTest {

     public:

        virtual ~UnitTest() { }

        virtual void runTests() { }

        static UnitTest& create() { return *new UnitTest(); }

    };

 //
 // Typedefs
 //

    class Value;
    class Frame;
    class Symbol;
    class Array;
    class String;
    class Stream;

 //
 // Symbols
 //

	extern Value _nil_;
	extern Value _Object_;
	extern Value _Float_;
    extern Value _LitNum_;

    extern char spaces[];
    extern int  indent;

}

#include "core/value.h"
#include "core/frame.h"

#include "protos/stream.h"

using namespace impulse::io;

#include "core/value_inline.h"
#include "core/frame_inline.h"


#endif
