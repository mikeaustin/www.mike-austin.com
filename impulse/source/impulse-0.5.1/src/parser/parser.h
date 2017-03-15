//
// parser/lexer.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include <cstring>

#include "../impulse.h"
#include "lexer.h"

namespace impulse { namespace parser {

 //
 // class *Parser
 //

    void Parser::parse( Express& code )
    {
        Token peek = _lexer.peekToken();

        if (peek.type() == &Parser::endstream)
        {
            quit = true;
            
            return;
        }

        this->initialize( code, lexer().token() );
        (this->*peek.type())( code, peek );
        this->finalize( code, lexer().token() );
    }

 //
 // class *Parser
 //

    class ExpressionParser : public Parser {

     public:

        ExpressionParser( Lexer& lexer ) : Parser( lexer ) { }

        void initialize( Express& expr, Token token );
        void finalize( Express& expr, Token token );

        void number( Express& expr, Token token );
        void stringx( Express& expr, Token token );
        void identifier( Express& expr, Token token );
        void keyword( Express& expr, Token token );
        void openexpr( Express& expr, Token token );
        void arrow( Express& expr, Token token );

    };

    class KeywordExpressionParser : public ExpressionParser {

     public:

        KeywordExpressionParser( Lexer& lexer ) : ExpressionParser( lexer ) { }

        void initialize( Express& expr, Token token );
        void finalize( Express& expr, Token token );

    };

    class SubexprExpressionParser : public ExpressionParser {

     public:

        SubexprExpressionParser( Lexer& lexer ) : ExpressionParser( lexer ) { }

        void initialize( Express& expr, Token token );
        void finalize( Express& expr, Token token );

    };


    class MessageParser : public Parser {

     public:

        MessageParser( Lexer& lexer ) : Parser( lexer ) { }

        void identifier( Express& expr, Token token );
        void keyword( Express& expr, Token token );
        void operatorx( Express& expr, Token token );
        void range( Express& expr, Token token );

    };

    class BinaryExpressionParser : public ExpressionParser {

     public:

        BinaryExpressionParser( Lexer& lexer ) : ExpressionParser( lexer ) { }

        void initialize( Express& expr, Token token );
        void finalize( Express& expr, Token token );

        void number( Express& expr, Token token );

    };


    class BinaryMessageParser : public MessageParser {

     public:

        BinaryMessageParser( Lexer& lexer ) : MessageParser( lexer ) { }

        void identifier( Express& expr, Token token );
        void operatorx( Express& expr, Token token );

    };

} }

#include "parsers/expression.h"
#include "parsers/message.h"

