//
// parser/token.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

namespace impulse { namespace parser {

    class Parser;

 //
 // class Token
 //
 // A token type is a pointer to a parser method, such as number() or keyword()
 //

    class Token : public Frame {

     public:

        typedef void (Parser::*Type)(Express&, Token);

        Token( Type type, Value value ) : _type( type ), _value( value ) { }

        Type type() { return _type; }
        Value value() { return _value; }

     private:

        Type  _type;
        Value _value;

    };

} }

