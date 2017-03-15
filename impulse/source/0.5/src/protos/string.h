//
// protos/string.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_STRING_H_
#define _IMPULSE_STRING_H_

#include <string>

namespace impulse {

 //
 // class String
 //

    class String : public Frame {

     public:

		String( string value = "" ) : _string( value ) { }

        string cstring() { return _string; }

        string inspect() { return "\"" + _string + "\""; }

        String& operator <<( double value ) { return _write( value, "%lf" ); }
        String& operator <<( long value ) { return _write( value, "%ld" ); }

     protected:

        template <typename T>
        String& _write( T value, const char* format );

     private:

        string _string;

    };

 //
 // class String
 //

    template <typename T>
    inline String& String::_write( T value, const char* format )
    {
        char buffer[256]; snprintf( buffer, 255, format, value );

        _string.append( buffer );

        return *this;
    }

    //Stream& operator <<( Stream& stream, String value )
    //{
    //    return stream.write( value.cstring() );
    //}

}

#endif
