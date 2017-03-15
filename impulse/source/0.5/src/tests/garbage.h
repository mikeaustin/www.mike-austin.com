//
// tests/garbage.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class GarbageTest : public UnitTest {

     public:

        void runTests()
        {
    		cout << "Testing Garbage..." << endl;
    		cout << "------------------------------------------------------------" << endl;

            Value lobby = new Lobby( _Object_.getFrame() );

            lobby.setSlot( Symbol::at("foo"), new GCArray( new Object(), new Object() ) );
            lobby.setSlot( Symbol::at("foo"), 10.0 );
            lobby.setSlot( Symbol::at("x"), 10.0 );
            lobby.setSlot( Symbol::at("y"), 10.0 );

    		cout << "------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}
