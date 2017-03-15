//
// protos/block.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_BLOCK_H_
#define _IMPULSE_BLOCK_H_

#include "../impulse.h"
#include "express.h"

namespace impulse {

 //
 // class Block
 //
 
 ///
 /// A block is a lexically scoped, deferred execution block of code, or closure.  A block takes
 /// the current execution context and arguments for the block as arguments.
 ///

    class Block : public Frame {

     public:

        Block( Frame* proto = _Block_.getFrame() ) : Frame( proto ) { }

        Block( Array* args, Express* expr = NULL ) : Frame( _Block_.getFrame() ), _args( args ), _expr( expr ) { }

        string inspect() { return "[Block]"; }

        Value call( Array& args, Value self )
        {
            Block& block = *self.get<Block>();
            //Frame* frame = new Frame( _env );
            Frame* frame = block._env;
            frame->setSlot( *block._args->at( 0 ).get<Symbol>(), args.at( 0 ) );

            Value result = block._expr->eval( args, frame );
            
            //delete frame;
            
            return result;
        }

        Array*   _args;
        Express* _expr;
        Frame*   _env;
    };

    class BlockProto : public Block {
    
     public:
     
        BlockProto() : Block( _Object_.getFrame() ) { }

        string inspect() { return "[BlockProto]"; }

        void initSlots()
        {
            setSlot( Symbol::at( "eval:" ), new Method<BlockProto>( &BlockProto::_call_ ) );
        }

        Value _call_( Array& args, Value self )
        {
            Block& block = *self.get<Block>();
            //Frame* frame = new Frame( _env );
            Frame* frame = block._env;
            frame->setSlot( *block._args->at( 0 ).get<Symbol>(), args.at( 0 ) );

            Value result = block._expr->eval( args, frame );
            
            //delete frame;
            
            return result;
        }

    };

    class Create : public Frame {
    
     public:
     
        Create( Array* args, Express* expr ) : _args( args ), _expr( expr ) { }
        
        Value eval( Array& args, Value self )
        {
            Block* block = new Block( _args, _expr );
            //block->_env = self.getFrame();
            block->_env = new Frame( self.getFrame() );

            return block;
        }

        Array*   _args;
        Express* _expr;

    };

}

#endif

