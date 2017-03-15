//
// tests/message.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class MessageTest : public UnitTest {

     public:

        void runTests()
        {
    		cout << "Testing Message..." << endl;
    		cout << "------------------------------------------------------------" << endl;
            trace << endl << "message.eval()" << endl;
            trace << "--------------------" << endl;

            Array args;
            Value v = 10.0;

            double ep = numeric_limits<double>::epsilon();

            Message message( Symbol::at("sin") );

            ASSERT( message.eval( args, 10.0 ).getFloat() > ::sin( 10.0 ) - ep );
            ASSERT( message.eval( args, 10.0 ).getFloat() < ::sin( 10.0 ) + ep );

            Message message2( Symbol::at("pow"), 2.0 );

            ASSERT( message2.eval( args, 10.0 ).getFloat() == ::pow( 10.0, 2.0 ) );

    		cout << "------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}
