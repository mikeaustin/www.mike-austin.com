//
// protos/symbol.cpp
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "../impulse.h"
#include "symbol.h"
#include "method.h"

using namespace std;

namespace impulse {

	Symbol::Symbol( string name ) : _name( name ) { }

    void Symbol::initSlots()
    {
		setSlot( Symbol::at( "foo" ), 10.0 );
		setSlot( Symbol::at( "bar" ), new Method<Symbol>( "bar", &Symbol::_getName ) );
    }

	Symbol& Symbol::at( string name )
	{
        //cout << "> Symbol::at( " << name << " )"<< endl;

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

        //cout << "< " << symbol << endl;

        return *symbol;
	}


	//map<string, Symbol*> Symbol::_symbols;

}
