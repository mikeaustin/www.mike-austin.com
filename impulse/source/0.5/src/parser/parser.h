//
// parser/lexer.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#include "../impulse.h"
#include "lexer.h"

#include <cstring>

namespace impulse { namespace parser {

 //
 // class *Parser
 //

    void Parser::parse( Express& code )
    {
        Token peek = _lexer.peekToken();

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
        void openexpr( Express& expr, Token token );

    };


    class SubexprExpressionParser : public ExpressionParser {

     public:

        void initialize( Express& expr, Token token );
        void finalize( Express& expr, Token token );

        SubexprExpressionParser( Lexer& lexer ) : ExpressionParser( lexer ) { }

    };


    class MessageParser : public Parser {

     public:

        MessageParser( Lexer& lexer ) : Parser( lexer ) { }

        void identifier( Express& expr, Token token );
        void operatorx( Express& expr, Token token );

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


 //
 // class ExpressionParser
 //

    void ExpressionParser::initialize( Express& expr, Token peek )
    {
        BEG( "Expression::initialize()" );
    }

    void ExpressionParser::finalize( Express& expr, Token peek )
    {
        END( "Expression::finalize()" );

        if (peek.type() != &Parser::terminator)
        {
            Token token = lexer().nextToken();
            
            cout << "*** Unexpected token: " << token.value().inspect() << endl;
        }
    }


    void ExpressionParser::number( Express& expr, Token peek )
    {
        BEG( "Expression::number( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        expr.push( token.value() );

        MessageParser( lexer() ).parse( expr );
        
        END( "" );
    }

    void ExpressionParser::stringx( Express& expr, Token peek )
    {
        BEG( "Expression::string( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        expr.push( token.value() );

        MessageParser( lexer() ).parse( expr );
        
        END( "" );
    }

    void ExpressionParser::identifier( Express& expr, Token peek )
    {
        BEG( "Expression::identifier( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        if (lexer().peekToken().type() == &Parser::assign)
        {
            BEG( "Expression::assign()" );

            lexer().nextToken();

            Express* arg2 = new Express( expr );
            expr.push( new Assign( *token.value().get<Symbol>(), *arg2 ) );

            ExpressionParser( lexer() ).parse( *arg2 );
            
            END( "" );
        }
        else
        {
            expr.push( new Message( *token.value().get<Symbol>() ) );

            MessageParser( lexer() ).parse( expr );
        }
        
        END( "" );
    }

    void ExpressionParser::openexpr( Express& expr, Token peek )
    {
        BEG( "Expression::openexpr()" );

        lexer().nextToken();

        Express* subexpr = new Express( expr );
        expr.push( subexpr );

        SubexprExpressionParser( lexer() ).parse( *subexpr );

        if (lexer().token().type() != &Parser::closeexpr)
        {
            cout << "Missing closing paren" << endl;
        }

        lexer().nextToken();

        MessageParser( lexer() ).parse( expr );

        END( "Expression::openexpr()" );
    }

//

    void SubexprExpressionParser::initialize( Express& expr, Token peek )
    {
        BEG( "SubExpression::initialize()" );
    }

    void SubexprExpressionParser::finalize( Express& expr, Token peek )
    {
        END( "SubExpression::finalize()" );
    }

 //
 // class MessageParser
 //

    void MessageParser::identifier( Express& expr, Token peek )
    {
        BEG( "Message::identifier( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        expr.push( new Message( *token.value().get<Symbol>() ) );

        MessageParser( lexer() ).parse( expr );
        
        END( "" );
    }

    void MessageParser::operatorx( Express& expr, Token peek )
    {
        BEG( "Message::operator( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        Express* arg1 = new Express( expr );

        expr.push( new Message( *token.value().get<Symbol>(), arg1 ) );

        BinaryExpressionParser( lexer() ).parse( *arg1 );

        END( "" );
    }

 //
 // class BinaryExpressionParser
 //

    void BinaryExpressionParser::number( Express& expr, Token peek )
    {
        BEG( "BinaryExpression::number( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        expr.push( token.value() );

        BinaryMessageParser( lexer() ).parse( expr );
        
        END( "" );
    }

    void BinaryExpressionParser::initialize( Express& expr, Token peek )
    {
        BEG( "BinaryExpression::initialize()" );
    }

    void BinaryExpressionParser::finalize( Express& expr, Token peek )
    {
        END( "BinaryExpression::finalize()" );
    }

 //
 // class BinaryMessageParser
 //

    void BinaryMessageParser::identifier( Express& expr, Token peek )
    {
        BEG( "Message::identifier( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        expr.push( new Message( *token.value().get<Symbol>() ) );

        BinaryMessageParser( lexer() ).parse( expr );
        
        END( "" );
    }

    void BinaryMessageParser::operatorx( Express& expr, Token peek )
    {
        BEG( "BinaryMessage::operator( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        Express* arg1 = new Express( expr.parent() );

        expr.parent().push( new Message( *token.value().get<Symbol>(), arg1 ) );

        BinaryExpressionParser( lexer() ).parse( *arg1 );
        
        END( "" );
    }

} }

