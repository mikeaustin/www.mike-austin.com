//
// protos/array.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_ARRAY_H_
#define _IMPULSE_ARRAY_H_

#include <vector>

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

		Array( unsigned int size = 0 ) : _size( size ), _memory( _array )
        {
            if (size > 10) _memory = new Value[size];
        }

		Array( Value value1 ) : _size( 1 ), _memory( _array )
        {
            _memory[0] = value1;
        }

		Array( Value value1, Value value2 ) : _size( 2 ), _memory( _array )
        {
            _memory[0] = value1;
            _memory[1] = value2;
        }

        string inspect() { return "[Array]"; }

        Value at( unsigned int i );
        Value atPut( unsigned int i, Value value );

        void push( Value value );
        void clear() { _size = 0; }

        unsigned int size() { return _size; }

        Value* data() { return _memory; }

     private:

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

		GCArray( Value value1 ) : Array( value1 )
        {
            value1.incrRef();
        }

		GCArray( Value value1, Value value2 ) : Array( value1, value2 )
        {
            value1.incrRef();
            value2.incrRef();
        }

        ~GCArray()
        {
            for (unsigned int i = 0; i < size(); i++)
            {
                data()[i].decrRef();
            }
        }

    };

 //
 // class Array
 //

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
            _memory[i].decrRef();

            value.incrRef();

            return _memory[i] = value;
        }
        else
        {
            return Value();
        }
    }


    inline void Array::push( Value value )
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
