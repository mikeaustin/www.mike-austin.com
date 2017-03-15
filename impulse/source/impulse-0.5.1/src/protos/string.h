//
// protos/string.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_STRING_H_
#define _IMPULSE_STRING_H_

#include <string>

#include "../impulse.h"
#include "array.h"

namespace impulse {

 //
 // class String
 //
 
 ///
 /// A string is a container for a sequence of characters.  A character is a string of one or more
 /// strings, not an integer - to better support utf-8.
 ///

    class String : public Frame {

     public:
     
        String( Frame* proto = _String_.getFrame() ) : Frame( proto ) { }
        String( string value ) : Frame( _String_.getFrame() ), _string( value ) { }

        string cstring() { return _string; }

        string inspect() { return "\"" + _string + "\""; }
        string toString() { return _string; }

        String& operator <<( double value ) { return _write( value, "%lf" ); }
        String& operator <<( long value ) { return _write( value, "%ld" ); }
        String& operator <<( string const& value ) { return _write( value.c_str(), "%s" ); }

     protected:

        template <typename T>
        String& _write( T value, const char* format );

     private:

        string _string;

    };

 //
 // class StringProto
 //
    
    class StringProto : public String {
    
     public:
     
        StringProto() : String( _Object_.getFrame() ) { }

        void initSlots();

        string inspect() { return "[StringProto]"; }

        Value _size( Array& args, Value self )
        {
            String& str = *self.get<String>();
            
            return str.cstring().size();
        }

        Value _split( Array& args, Value self )
        {
            String& str = *self.get<String>();
            Array* array = new Array();
            
            for (unsigned int i = 0; i < str.cstring().size(); i++)
            {
                array->push( string( 1, str.cstring()[i] ) );
            }

            return array;
        }
            
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

