//
// protos/lobby.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_LOBBY_H_
#define _IMPULSE_LOBBY_H_

#include <cstdlib>

#include "../impulse.h"

namespace impulse {

 //
 // class Lobby
 //

 ///
 /// Lobby is the root, or global context in Impulse.
 ///

    class Lobby : public Frame {

     public:

        Lobby( Frame* proto = _Lobby_.getFrame() ) : Frame( proto ) { }

        string inspect() { return "[Lobby]"; }

    };

    class LobbyProto : public Lobby {
    
     public:

        LobbyProto() : Lobby( _Object_.getFrame() ) { }
     
		void initSlots()
        {
            setSlot( Symbol::at( "version" ), new String( "Impulse 0.5" ) );
            setSlot( Symbol::at( "puts:" ), new Method<LobbyProto>( &LobbyProto::_puts_ ) );
            setSlot( Symbol::at( "exit" ), new Method<LobbyProto>( &LobbyProto::_exit ) );
            setSlot( Symbol::at( "random" ), new Method<LobbyProto>( &LobbyProto::_random ) );
        }

        string inspect() { return "[LobbyProto]"; }

        Value _puts_( Array& args, Value self ) {
            cout << args.at( 0 ).toString() << endl;
            
            return _nil_;
        }

        Value _exit( Array& args, Value self ) {
            quit = true;
            
            return _nil_;
        }

        Value _random( Array& args, Value self ) {
            return (float) rand() / (float) RAND_MAX - 0.5;
        }
     
    };

}

#endif

