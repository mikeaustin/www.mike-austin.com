//
// tests/express.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class ExpressTest : public UnitTest {

     public:

        void runTests()
        {
            cout << "Testing Express..." << endl;
            cout << "--------------------------------------------------------------------------------" << endl;

            Value lobby = new Lobby();

            Express expr;
            expr.push( Value(-10.0) );
            expr.push( new Message( Symbol::at( "abs" ) ) );

            Array args;
            Value value;

            //for (int i = 0; i < 50000000; i++)
            {
                value = expr.invoke( args, lobby );
            }

            ASSERT( value.getFloat() == 10.0 );

            //Array args2( 5.0 );
            //Array code2( Value( 10.0 ), new Message( Symbol::at( "+" ), string("foo") ) );
            //Block block2( code2 );
            //ASSERT( block2.invoke( args, lobby ).getFloat() == 15.0 );

            Array args2;

            Express code3;
            code3.push( Value( 5.0 ) );

            Express code2;
            code2.push( Value( 10.0 ) );
            code2.push( new Message( Symbol::at( "+" ), &code3 ) );

            ASSERT( code2.invoke( args, lobby ).getFloat() == 15.0 );

            cout << "--------------------------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}

