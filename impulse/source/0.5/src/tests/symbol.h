//
// tests/symbol.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class SymbolTest : public UnitTest {

     public:

        void runTests()
        {
    		cout << "Testing Symbol..." << endl;
    		cout << "------------------------------------------------------------" << endl;

            if (true)
            {
                Frame frame;

                frame.setSlot( Symbol::at("foo"), 10.0 );

                OUTPUT( "-- Symbol equality" );
                ASSERT( Symbol( "foo" ).getName() == "foo" );
                ASSERT( &Symbol::at("foo") == &Symbol::at("foo") );
                ASSERT( &Symbol::at("foo") != &Symbol::at("bar") );
            }

    		cout << "------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}
