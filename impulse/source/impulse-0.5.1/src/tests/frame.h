//
// tests/frame.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse {

    class FrameTest : public UnitTest {

     public:

        static UnitTest& create() { return *new FrameTest(); }

        void runTests();

    };


    void FrameTest::runTests()
    {
		cout << "Testing Frame..." << endl;
            cout << "--------------------------------------------------------------------------------" << endl;

        if (true)
        {
            Frame frame;
            Symbol foo( "foo" );

            OUTPUT( "-- Set and get slots" );
            ASSERT( frame.setSlot( foo, 10.0 ).getFloat() == Value( 10.0 ).getFloat() );
            ASSERT( frame.getSlot( foo ).getFloat() == 10.0 );
            ASSERT( frame.getSlot( foo ).getFloat() != 15.0 );

            Array args;
            args.push( 10 );

            OUTPUT( "-- eval()" );

            ASSERT( Value( 10.0 ).eval( args, 10.0 ).getFloat() == 10.0 );
            ASSERT( frame.eval( args, 10.0 ).getFrame() == &frame );

            OUTPUT( "-- send()" );
            ASSERT( frame.send( foo, args ).getFrame() == frame.getSlot( foo ).getFrame() );
/*
            trace << "frame.send( &frame, Symbol::at( \"test\"), args )" << endl;
            trace << "--------------------" << endl;

            OUTPUT( "-- Proto lookup" );
            frame.proto() = _Object_.getFrame();

            frame.send( Symbol::at( "test" ), args );
            ASSERT( frame.getSlot( Symbol::at( "foo" ) ).getFloat() == 15.0 );
*/
        }

            cout << "--------------------------------------------------------------------------------" << endl;
        cout << endl;
    }

}

