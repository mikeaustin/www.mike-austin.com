//
// protos/symbol.cpp
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "../impulse.h"
#include "symbol.h"
#include "method.h"
#include "block.h"

using namespace std;

namespace impulse {

	Symbol& Symbol::at( string name )
	{
    	static map<string, Symbol*>& _symbols = *new map<string, Symbol*>;
        Symbol* symbol = NULL;

		if (_symbols.find( name ) != _symbols.end())
        {
			symbol = _symbols[name];
        }
        else
        {
			symbol = _symbols[name] = new Symbol( name );
        }

        return *symbol;
	}

	//map<string, Symbol*> Symbol::_symbols;

    void SymbolProto::initSlots()
    {
		setSlot( Symbol::at( "foo" ), 10.0 );
		setSlot( Symbol::at( "bar" ), new Method<SymbolProto>( &SymbolProto::_getName ) );
    }

    void ArrayProto::initSlots()
    {
        setSlot( Symbol::at( "size" ), new Method<ArrayProto>( &ArrayProto::_size ) );
        setSlot( Symbol::at( "," ), new Method<ArrayProto>( &ArrayProto::_append_ ) );
        setSlot( Symbol::at( "each:" ), new Method<ArrayProto>( &ArrayProto::_each_ ) );
        setSlot( Symbol::at( "join:" ), new Method<ArrayProto>( &ArrayProto::_join_ ) );
    }

    void StringProto::initSlots()
    {
        setSlot( Symbol::at( "size" ), new Method<StringProto>( &StringProto::_size ) );
        setSlot( Symbol::at( "split" ), new Method<StringProto>( &StringProto::_split ) );
    }

    Value ArrayProto::_each_( Array& args, Value self )
    {
        Array& array = *self.get<Array>();
        Block& block = *args.at( 0 ).get<Block>();

        Array blockArgs( 1 );
        
        for (unsigned int i = 0; i < array.size(); i++)
        {
            blockArgs.atPut( 0, i );
            block.call( blockArgs, &block );
        }
        
        return _nil_;

    }

    Value ArrayProto::_join_( Array& args, Value self )
    {
        Array& array = *self.get<Array>();
        String& join = *args.at( 0 ).get<String>();
        string str;
        
        for (unsigned int i = 0; i < array.size(); i++)
        {
            if (i != 0) str += join.cstring();
            str += array.data()[i].toString();
        }
        
        return str;
    }

}

