//
// impulse.cpp
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "impulse.h"

#include "protos/nil.h"
#include "protos/symbol.h"
#include "protos/method.h"
#include "protos/array.h"
#include "protos/express.h"
#include "protos/string.h"
#include "protos/block.h"
#include "protos/range.h"
#include "protos/object.h"
#include "protos/message.h"
#include "protos/stream.h"
#include "protos/float.h"
#include "protos/lobby.h"
#include "protos/point.h"

#include "protos/socket.h"
#include "protos/opengl.h"

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
    Stream io::trace( "trace.log", Stream::OverWrite );

    Value _nil_      = new NilProto();
    Value _Object_   = new ObjectProto();
    Value _Float_    = new FloatProto();
    Value _LitNum_   = new Float();
    Value _Symbol_   = new SymbolProto();
    Value _String_   = new StringProto();
    Value _Range_    = new RangeProto();
    Value _Array_    = new ArrayProto();
    Value _Block_    = new BlockProto();
    Value _Point_    = new PointProto();
    Value _LitPoint_ = new Point();
    Value _Lobby_    = new LobbyProto();

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
        //SocketTest().runTests();
    }

}

//
// main()
//

using namespace impulse;

bool quit = false;

int main( int argc, char* argv[] )
{
    cout << "Impulse 0.5.1 - Copyright (c) 2008-2009, Mike Austin" << endl;
    cout << "--------------------------------------------------------------------------------" << endl;

    cout << "sizeof( Value )  = " << sizeof( impulse::Value ) << endl;
    cout << "sizeof( Frame )  = " << sizeof( impulse::Frame ) << endl;
    cout << "sizeof( double ) = " << sizeof( double ) << endl;
    cout << "sizeof( long )   = " << sizeof( long ) << endl;

    cout << "--------------------------------------------------------------------------------" << endl;
    cout << endl;

    _nil_.getFrame()->initSlots();
    _Object_.getFrame()->initSlots();
    _Float_.getFrame()->initSlots();
    _Symbol_.getFrame()->initSlots();
    _String_.getFrame()->initSlots();
    _Range_.getFrame()->initSlots();
    _Array_.getFrame()->initSlots();
    _Point_.getFrame()->initSlots();
    _Block_.getFrame()->initSlots();
    _Lobby_.getFrame()->initSlots();
#if defined(_IMPULSE_OPENGL_H_)
    _OpenGL_.getFrame()->initSlots();
#endif

    impulse::runAllTests();

    Stream& stream = argc > 1 ? *new Stream( argv[1] ) : cin;

    parser::Lexer lexer( stream );
    Express expr;

    while (!quit)
    {
        parser::ExpressionParser parser = parser::ExpressionParser( lexer );

        if (&stream == &cin) cout << "] ";

        lexer.reset();
        expr.clear();

        parser.parse( expr );

        Array args;
        Value result = expr.eval( args, _Lobby_ );

        if (&stream == &cin) cout << result.inspect() << endl;
    }

    return 0;
}

