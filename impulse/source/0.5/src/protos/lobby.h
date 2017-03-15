//
// protos/lobby.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_LOBBY_H_
#define _IMPULSE_LOBBY_H_

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

		Lobby( Frame* proto = NULL ) : Frame( proto )
        {
            setSlot( Symbol::at("version"), new String( "Impulse 0.5" ) );
            setSlot( Symbol::at("exit"), new Method<Lobby>( "exit", &Lobby::_exit ) );
        }

        string inspect() { return "[Lobby]"; }

        string version()
        {
            BEG( "Lobby::version()" );

            END( "" );

            return "Impulse 0.5";
        }

     protected:

        Value _version( Array& args, Value self ) {
            return version();
        }

        Value _exit( Array& args, Value self ) {
            ::exit( 0 );
        }

    };

}

#endif
