namespace impulse { namespace parser {

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

    void MessageParser::keyword( Express& expr, Token peek )
    {
        BEG( "Message::keyword( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        Express* arg1 = new Express();
        expr.push( new Message( *token.value().get<Symbol>(), arg1 ) );

        KeywordExpressionParser( lexer() ).parse( *arg1 );
        
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

    void MessageParser::range( Express& expr, Token peek )
    {
        BEG( "Message::range( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        //Express* arg1 = new Express( expr );

        expr.push( new Message( *token.value().get<Symbol>(), lexer().nextToken().value() ) );

        SubexprExpressionParser( lexer() ).parse( expr );

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

