//
// tests/float.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class FloatTest : public UnitTest {

     public:

        void runTests()
        {
    		cout << "Testing Float..." << endl;
            cout << "--------------------------------------------------------------------------------" << endl;

            Array args;
            args.push( 10.0 );

            double ep = numeric_limits<double>::epsilon();

            OUTPUT( "---- ep = " << ep );
            ASSERT( FloatProto()._sin( args, 10.0 ).getFloat() > ::sin( 10.0 ) - ep );
            ASSERT( FloatProto()._sin( args, 10.0 ).getFloat() < ::sin( 10.0 ) + ep );

            Array args2;
            args2.push( 2.0 );
            args2.push( 10.0 );

            ASSERT( FloatProto()._pow_( args2, 10.0 ).getFloat() == ::pow( 10.0, 2.0 ) );

            cout << "--------------------------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}

