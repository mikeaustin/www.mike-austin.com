//
// protos/socket.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_SOCKET_H_
#define _IMPULSE_SOCKET_H_

#include <sys/types.h>
#ifdef _WIN32
 #define _WIN32_WINNT 0x0501
 #include <winsock2.h>
 #include <ws2tcpip.h>
#else
 #include <sys/socket.h>
 #include <netdb.h>
#endif
#include <cstring>

#include "../impulse.h"

namespace impulse {

 //
 // class Socket
 //

    class Socket : public Frame {

     public:

        Socket( string host, string protocol )
        {
            _info = getInfo( "www.sun.com", "http" );

            _socket = socket( _info->ai_family, _info->ai_socktype, _info->ai_protocol );
            cout << "socket = " << _socket << endl;

            int result = ::connect( _socket, _info->ai_addr, _info->ai_addrlen );
            cout << "connect = " << result << endl;
            
            freeaddrinfo( _info );
        }

        void initSlots()
        {
            //setSlot( Symbol::at( "test" ), new Method<Object>( &Object::_test ) );
            //setSlot( Symbol::at( "set-slot" ), new Method<Object>( &Object::_setSlot_ ) );
        }

        string inspect() { return "[Socket]"; }

        addrinfo* getInfo( string host, string protocol )
        {
            addrinfo hints;
            memset( &hints, 0, sizeof( hints ) );
            hints.ai_family   = AF_UNSPEC;
            hints.ai_socktype = SOCK_STREAM;
            
            int result = getaddrinfo( host.c_str(), protocol.c_str(), &hints, &_info );
            cout << "getaddrinfo = " << result << endl;
            
            return _info;
        }

        void send( const char* data )
        {
            int result = ::send( _socket, data, strlen( data ), 0 );
            cout << "send = " << result << endl;
        }

        void send( const void* data, int length )
        {
            int result = ::send( _socket, (char*) data, length, 0 );
            cout << "send = " << result << endl;
        }

        string receive()
        {
            char buffer[4096];
            
            int length = ::recv( _socket, buffer, 4095, 0 );
            cout << "recv = " << length << endl;
            buffer[length] = '\0';
            
            return buffer;
        }

     protected:

        Value _test( Array& args, Value self )
        {
            BEG( "Object::_test()" );

            Value result = self.setSlot( Symbol::at( "foo" ), 15.0 );

            END( "" );

            return result;
        }

        Value _setSlot_( Array& args, Value self )
        {
            return setSlot( *args.at( 0 ).get<Symbol>(), args.at( 1 ) );
        }

     private:
     
        int       _socket;
        addrinfo* _info;

    };

}

#endif

