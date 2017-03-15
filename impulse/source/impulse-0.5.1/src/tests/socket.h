//
// tests/socket.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class SocketTest : public UnitTest {

     public:

        void runTests()
        {
    		cout << "Testing Socket..." << endl;
            cout << "--------------------------------------------------------------------------------" << endl;

            Socket socket( "www.sun.com", "http" );
            socket.send( "get\r\n" );
            cout << socket.receive() << endl;

            cout << "--------------------------------------------------------------------------------" << endl;
            cout << endl;
        }

    };

}

