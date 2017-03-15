//
// tests/method.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    struct Test : public Frame {

        Value test( Array& args, Value self ) { return args.at(0).getFloat() + 10.0; }

    };

    class MethodTest : public UnitTest {

     public:

        void runTests()
        {
    		cout << "Testing Method..." << endl;
    		cout << "------------------------------------------------------------" << endl;

            Array args;
            args.push( 5 );

            Array margs;
            margs.push( new Test() );
            margs.push( &args );

            Frame* method;
            ASSERT( method = new Method<Test>( "test", &Test::test ) );

            try
            {
                ASSERT( method->eval( margs, 10.0 ).getFloat() == 15.0 );
            }
            catch( string error )
            {
                cout << error << endl;
            }

    		cout << "------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}
