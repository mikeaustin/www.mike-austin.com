//
// parser/lexer.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include <cstring>

#include "../impulse.h"
#include "token.h"

namespace impulse { namespace parser {

 //
 // class Lexer
 //

    class Lexer : public Frame {

     public:

        Lexer( Stream& stream );

        Token nextToken();
        Token peekToken();
        Token token() { return _token; }

        void reset();

        Token readNumber();
        Token readOperator();
        Token readIdentifier();
        Token readString();
        Token readSubexpr();
        Token readAssign();
        Token readTerminator();
        Token readComment();

     private:

        Stream& _stream;
        //String  _buffer2;
        char    _buffer[256];
        vector<Token (Lexer::*)()> _readers;
        Token  _peek;
        Token  _token;

    };

 //
 // class Parser
 //

    class Parser : public Frame {

     public:

        Parser( Lexer& lexer ) : _lexer( lexer ) { }

        Lexer& lexer() { return _lexer; }

        void parse( Express& expr );

        virtual void initialize( Express&, Token token )      { }
        virtual void finalize( Express& expr, Token token )   { }

        virtual void peek( Express& expr, Token token )       { }

        virtual void nil( Express& expr, Token token )        { }
        virtual void number( Express& expr, Token token )     { }
        virtual void stringx( Express& expr, Token token )    { }
        virtual void operatorx( Express& expr, Token token )  { }
        virtual void identifier( Express& expr, Token token ) { }
        virtual void keyword( Express& expr, Token token )    { }
        virtual void range( Express& expr, Token token )      { }
        virtual void openexpr( Express& expr, Token token )   { }
        virtual void closeexpr( Express& expr, Token token )  { }
        virtual void assign( Express& expr, Token token )     { }
        virtual void arrow( Express& expr, Token token )      { }
        virtual void terminator( Express& expr, Token token ) { }
        virtual void endstream( Express& expr, Token token )  { }
        virtual void comment( Express& expr, Token token )    { }

     private:

        Lexer& _lexer;

    };

 //
 // class Lexer
 //

    Lexer::Lexer( Stream& stream ) : _stream( stream ), _peek( Token( &Parser::peek, _nil_ ) ),
     _token( Token( &Parser::nil, _nil_ ) )
    {
        _readers.push_back( &Lexer::readComment );
        _readers.push_back( &Lexer::readNumber );
        _readers.push_back( &Lexer::readString );
        _readers.push_back( &Lexer::readOperator );
        _readers.push_back( &Lexer::readIdentifier );
        _readers.push_back( &Lexer::readSubexpr );
        _readers.push_back( &Lexer::readAssign );
        _readers.push_back( &Lexer::readTerminator );
    }

    Token Lexer::nextToken()
    {
        if (_peek.type() != &Parser::peek )
        {
            Token token = _peek;

            _peek = Token( &Parser::peek, _nil_ );

            return token;
        }

        while( _stream.peek() == ' ' || _stream.peek() == '\t' ) _stream.getc();

        memset( _buffer, 0, 256 );

        for (unsigned int i = 0; i < _readers.size(); i++)
        {
            _token = (this->*_readers[i])();

            if (_token.type() != &Parser::nil) return _token;
        }

        _buffer[0] = _stream.getc();

        _token = Token( &Parser::nil, &Symbol::at( _buffer ) );

        return _token;
    }

    void Lexer::reset()
    {
        _peek  = Token( &Parser::peek, _nil_ );
        _token = Token( &Parser::nil, _nil_ );
    }

    Token Lexer::peekToken()
    {
        if (_peek.type() != &Parser::peek) return _peek;

        _peek = nextToken();

        return _peek;
    }

} }

#include "reader.h"

