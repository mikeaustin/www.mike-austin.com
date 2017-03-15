//
// protos/range.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_RANGE_H_
#define _IMPULSE_RANGE_H_

#include "../impulse.h"
#include "block.h"

namespace impulse {

    extern Value _Range_;

 //
 // class Range
 //

 ///
 /// A Range is an virtual list of numbers, with a starting and ending number, inclusive.
 ///

    class Range : public Frame {

     public:

        Range( int from = 0, int to = 0 ) : Frame( _Range_.getFrame() ), _from( from ), _to( to ) { }
        Range( Frame* proto ) : Frame( proto ), _from( 0 ), _to( 0 ) { }

        string inspect() { char buffer[256]; sprintf(buffer, "%d..%d", _from, _to); return buffer; }
        string toString() { char buffer[256]; sprintf(buffer, "%d..%d", _from, _to); return buffer; }

        unsigned int from() { return _from; }
        unsigned int to() { return _to; }

        unsigned int size() { return _to - _from + 1; }

        unsigned int sum()
        {
            int sum = 0;
            
            for (int i = _from; i <= _to; i++)
            {
                sum += i;
            }

            return sum;
        }

        unsigned int product()
        {
            int product = 1;

            for (int i = _from; i <= _to; i++)
            {
                product *= i;
            }

            return product;
        }

     private:

        int _from, _to;

    };

 //
 // class RangeProto
 //

    class RangeProto : public Range {

     public:

        RangeProto() : Range( _Object_.getFrame() ) { }

        string inspect() { return "[RangeProto]"; }
     
        void initSlots()
        {
            setSlot( Symbol::at( "size" ), new Method<RangeProto>( &RangeProto::_size ) );
            setSlot( Symbol::at( "sum" ), new Method<RangeProto>( &RangeProto::_sum ) );
            setSlot( Symbol::at( "product" ), new Method<RangeProto>( &RangeProto::_product ) );
            setSlot( Symbol::at( "each:" ), new Method<RangeProto>( &RangeProto::_each_ ) );
            setSlot( Symbol::at( "map:" ), new Method<RangeProto>( &RangeProto::_map_ ) );
        }

     protected:
     
        Value _size( Array& args, Value self )      { return self.get<Range>()->size(); }
        Value _sum( Array& args, Value self )       { return self.get<Range>()->sum(); }
        Value _product( Array& args, Value self )   { return self.get<Range>()->product(); }
        Value _each_( Array& args, Value self )
        {
            Range& range = *self.get<Range>();
            Block& block = *args.at( 0 ).get<Block>();

            Array blockArgs( 1 );
            
            for (unsigned int i = range.from(); i <= range.to(); i++)
            {
                blockArgs.atPut( 0, i );
                block.call( blockArgs, &block ).getFloat();
            }
            
            return _nil_;
        }

        Value _map_( Array& args, Value self )
        {
            Range& range = *self.get<Range>();
            Block& block = *args.at( 0 ).get<Block>();

            Array* values = new Array();
            Array blockArgs( 1 );
            
            for (unsigned int i = range.from(); i <= range.to(); i++)
            {
                blockArgs.atPut( 0, i );
                values->push( block.call( blockArgs, &block ) );
            }
            
            return values;
        }
    };

}

#endif

