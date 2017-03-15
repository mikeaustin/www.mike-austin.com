//
// tests/value.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class ValueTest : public UnitTest {

     public:

        static UnitTest& create() { return *new ValueTest(); }

        void runTests()
        {
    		cout << "Testing Value..." << endl;
            cout << "--------------------------------------------------------------------------------" << endl;

            ASSERT( Value( 10.0 ).getFloat() == 10.0 );
            ASSERT( Value( 10.0 ).getFloat() != 15.0 );

            ASSERT( Value("foo").get<String>()->cstring() == "foo" );
            ASSERT( Value("foo").get<String>()->cstring() != "bar" );

            cout << "--------------------------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}

