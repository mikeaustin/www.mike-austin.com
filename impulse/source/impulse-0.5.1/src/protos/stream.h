//
// protos/stream.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_STREAM_H_
#define _IMPULSE_STREAM_H_

#include <cstdlib>

#include "../impulse.h"

namespace impulse {

 //
 // class Stream
 //

 ///
 /// A Stream provides a means of input and output, to and from the console or a file.
 ///

    class Stream : public Frame {

     public:

        enum Mode { ReadOnly, ReadWrite, OverWrite, Append };

        Stream() : _file( NULL ) { }
        Stream( FILE* file ) : _file( file ) { }
        Stream( string name, Mode mode = ReadOnly )
        {
            const char* fmode = "";
            
            switch( mode )
            {
                case ReadOnly:   fmode = "r"; break;
                case ReadWrite:  fmode = "r+"; break;
                case OverWrite:  fmode = "w"; break;
                case Append:     fmode = "a"; break;
            }
            
            _file = fopen( name.c_str(), fmode );
        }

        string inspect() { return "[Symbol]"; }

        Stream& operator <<( double value )         { fprintf( _file, "%lf", value ); return *this; }
        Stream& operator <<( const char* value )    { if (_file) fprintf( _file, "%s", value ); return *this; }
        Stream& operator <<( string value )         { if (_file) fprintf( _file, "%s", value.c_str() ); return *this; }
        Stream& operator <<( int value )            { if (_file) fprintf( _file, "%d", value ); return *this; }
        Stream& operator <<( long value )           { if (_file) fprintf( _file, "%ld", value ); return *this; }
        Stream& operator <<( unsigned int value )   { if (_file) fprintf( _file, "%u", value ); return *this; }
        Stream& operator <<( unsigned long value )  { if (_file) fprintf( _file, "%lu", value ); return *this; }
        Stream& operator <<( bool value )           { if (_file) fprintf( _file, "%d", value ); return *this; }
        Stream& operator <<( void* value )          { if (_file) fprintf( _file, "%p", value ); return *this; }

        Stream& operator >>( long c )               { return ::fgetc( _file ), *this; }

        long peek() { int c = ::fgetc( _file ); ::ungetc( c, _file ); return c; }
        long getc() { return ::fgetc( _file ); }

        long unget( int c ) { return ::ungetc( c, _file ); }

        inline Stream& operator <<( Stream& (*func)(Stream&) )
        {
            return (*func)(*this);
        }

        Stream& flush()                      { if (_file) fflush( _file ); return *this; }

     private:

        FILE* _file;

    };

 //
 // Stream operators
 //

    namespace io {

        inline Stream& endl( Stream& stream )
        {
            return stream << "\n", stream.flush();
        }

        extern Stream cin;
        extern Stream cout;
        extern Stream trace;

    }

}

#endif

