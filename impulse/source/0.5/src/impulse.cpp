//
// impulse.cpp
//
// g++-4 -Wall -Wfatal-errors -Icore impulse.cpp core/*.cpp protos/*.cpp && ./a.exe
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "impulse.h"
#include "protos/array.h"
#include "protos/method.h"
#include "protos/express.h"
#include "protos/nil.h"
#include "protos/string.h"
#include "protos/symbol.h"
#include "protos/object.h"
#include "protos/message.h"
#include "protos/stream.h"
#include "protos/float.h"
#include "protos/lobby.h"
#include "protos/socket.h"

#include "tests/value.h"
#include "tests/frame.h"
#include "tests/method.h"
#include "tests/symbol.h"
#include "tests/express.h"
#include "tests/float.h"
#include "tests/message.h"
#include "tests/garbage.h"
#include "tests/socket.h"

#include "parser/parser.h"

namespace impulse {

 //
 // Symbols
 //

    char spaces[] = "                                                            ";
    int  indent   = 0;

    Stream io::cin( stdin );
    Stream io::cout( stdout );
    Stream io::trace( "trace.log" );

	Value _nil_    = new Nil();
	Value _Float_  = new Float();
	Value _LitNum_ = new Float();
    Value _Object_ = new Object();
    Value _Symbol_ = new Symbol();

 //
 // Unit Tests
 //

    void runAllTests()
    {
        UnitTest& (*testFunc[])() = { ValueTest::create, ValueTest::create };
        int tests = sizeof(testFunc) / sizeof(void (*)());

        for (int i = 0; i < tests; i++)
        {
            //UnitTest& test = testFunc[i]();
            //test.runTests();
        }

        ValueTest().runTests();
        FrameTest().runTests();
        SymbolTest().runTests();
        MethodTest().runTests();
        FloatTest().runTests();
        ExpressTest().runTests();
        MessageTest().runTests();
        GarbageTest().runTests();
        SocketTest().runTests();
    }

}

//
// main()
//

using namespace impulse;

int main( int argc, char* argv[] )
{
    cout << "Impulse 0.5 - Copyright (c) 2008-2009, Mike Austin" << endl;
    cout << "------------------------------------------------------------" << endl;

    cout << "sizeof( Value )  = " << sizeof( impulse::Value ) << endl;
    cout << "sizeof( Frame )  = " << sizeof( impulse::Frame ) << endl;
    cout << "sizeof( double ) = " << sizeof( double ) << endl;
    cout << "sizeof( long )   = " << sizeof( long ) << endl;

    cout << "------------------------------------------------------------" << endl;

    _nil_.getFrame()->initSlots();
    _Float_.getFrame()->initSlots();
    _LitNum_.getFrame()->proto() = _Float_.getFrame();
    _Object_.getFrame()->initSlots();
    _Symbol_.getFrame()->initSlots();

#ifdef DEBUG
    impulse::runAllTests();
#endif

    Value lobby = new Lobby( _Object_.getFrame() );

    parser::Lexer lexer( cin );
    Express expr;

    for (;;)
    {
        parser::ExpressionParser parser = parser::ExpressionParser( lexer );

        cout << "] ";

        lexer.reset();
        expr.clear();

        parser.parse( expr );

        Array args;
        cout << expr.eval( args, lobby ).inspect() << endl;
    }

    return 0;
}
