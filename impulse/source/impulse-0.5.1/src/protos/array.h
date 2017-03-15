//
// protos/array.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_ARRAY_H_
#define _IMPULSE_ARRAY_H_

#include <vector>

#include "../impulse.h"

namespace impulse {

 //
 // class Array
 //

 ///
 /// An Array is a sequential block of Values, indexed by number.  If the array size is less than
 /// 10, it uses an inline array for quick access, else it allocates a dynamic array.  If a value
 /// is set outside of bounds of the array, the value is stored in a hash.  This allows it to be
 /// used as a sparse array.
 ///

    class Array : public Frame {

     public:

		Array( Frame* proto = _Array_.getFrame() ) : Frame( proto ), _size( 0 ), _memory( _array ) { }
		Array( Value value1 );
		Array( Value value1, Value value2 );

        ~Array() { }

        string inspect()
        {
            char buffer[4096];
            int  pos = 0;
            
            for (unsigned int i = 0; i < size(); i++)
            {
                pos += snprintf( buffer + pos, 4095 - pos, "%s, ", data()[i].inspect().c_str() );
            }
            
            buffer[pos - 2] = '\0';

            return buffer;
        }

        string toString()
        {
            char buffer[4096];
            int  pos = 0;
            
            for (unsigned int i = 0; i < size(); i++)
            {
                pos += snprintf( buffer + pos, 4095 - pos, "%s, ", data()[i].inspect().c_str() );
            }
            
            buffer[pos - 2] = '\0';

            return buffer;
        }

        Value at( unsigned int i );
        Value atPut( unsigned int i, Value value );

        void push( Value value );
        void clear() { _size = 0; }

        unsigned int size() { return _size; }

        Value* data() { return _memory; }

     protected:

        unsigned int  _size;
        Value         _array[10];
        Value*        _memory;
        bool          _usegc;

    };

 //
 // class GCArray
 //

    class GCArray : public Array {

     public:

		GCArray( Frame* proto = _Array_.getFrame() ) : Array( proto ) { }

		GCArray( Value value1 ) : Array( value1 )
        {
            value1.incrRef();
        }

		GCArray( Value value1, Value value2 ) : Array( value1, value2 )
        {
            value1.incrRef();
            value2.incrRef();
        }

        Value atPut( unsigned int i, Value value );
        void push( Value value );

        ~GCArray()
        {
            for (unsigned int i = 0; i < size(); i++)
            {
                data()[i].decrRef();
            }
        }

    };

    class ArrayProto : public GCArray {

     public:

        ArrayProto() : GCArray( _Object_.getFrame() ) { }
     
        void initSlots();

        string inspect() { return "[ArrayProto]"; }

        Value _append_( Array& args, Value self )
        {
            return self.get<Array>()->push( args.at( 0 ) ), self;
        }

        Value _size( Array& args, Value self )
        {
            Array& array = *self.get<Array>();

            return array.size();
        }

        Value _each_( Array& args, Value self );
        Value _join_( Array& args, Value self );

    };

 //
 // class Array
 //

	inline Array::Array( Value value1 ) : Frame( _Array_.getFrame() ), _size( 1 ), _memory( _array )
    {
        _memory[0] = value1;
    }

	inline Array::Array( Value value1, Value value2 ) : Frame( _Array_.getFrame() ), _size( 2 ), _memory( _array )
    {
        _memory[0] = value1;
        _memory[1] = value2;
    }

    inline Value Array::at( unsigned int i )
    {
        if (i < _size)
        {
            return _memory[i];
        }
        else
        {
            return _nil_;
        }
    }

    inline Value Array::atPut( unsigned int i, Value value )
    {
        if (i < _size)
        {
            return _memory[i] = value;
        }
        else
        {
            return _nil_;
        }
    }

    inline void Array::push( Value value )
    {
        if (_size >= 10)
        {
            cout << "Array::push() not fully implemented" << endl;
        }

        _memory[_size++] = value;
    }

 //
 // GCArray
 //
 
    inline Value GCArray::atPut( unsigned int i, Value value )
    {
        if (i < _size)
        {
            _memory[i].decrRef();
            value.incrRef();

            return _memory[i] = value;
        }
        else
        {
            return _nil_;
        }
    }

    inline void GCArray::push( Value value )
    {
        if (_size >= 10)
        {
            cout << "Array::push() not fully implemented" << endl;
        }

        value.incrRef();

        _memory[_size++] = value;
    }

}

#endif

