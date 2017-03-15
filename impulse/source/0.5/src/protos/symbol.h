//
// protos/symbol.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_SYMBOL_H_
#define _IMPULSE_SYMBOL_H_

#include <string>
#include <map>

#include "../impulse.h"

namespace impulse {

 //
 // class Symbol
 //

 ///
 /// A Symbol is an unique identifier, used for selectors in messages and keys in hash maps.
 ///

    class Symbol : public Frame {

     public:

		Symbol( string name = "" );

        void initSlots();

        string inspect() { return string("#") + _name; }

        string getName() { return _name; }

		static Symbol& at( string name );

     protected:

        Value _getName( Array& args, Value self )    { return getName(); }

     private:

        string _name;

		static map<string, Symbol*> _symbols;

    };

}

#endif
