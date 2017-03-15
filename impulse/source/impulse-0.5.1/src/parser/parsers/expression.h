namespace impulse { namespace parser {

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

            SubexprExpressionParser( lexer() ).parse( *arg2 );
            
            END( "" );
        }
        else if (lexer().peekToken().type() == &Parser::arrow)
        {
            Array* args = new Array();
            args->push( token.value().get<Symbol>() );

            lexer().nextToken();

            Express* blockExpr = new Express();
            Create* block = new Create( args, blockExpr );
            expr.push( block );

            SubexprExpressionParser( lexer() ).parse( *blockExpr );
        }
        else
        {
            expr.push( new Message( *token.value().get<Symbol>() ) );

            MessageParser( lexer() ).parse( expr );
        }
        
        END( "" );
    }

    void ExpressionParser::keyword( Express& expr, Token peek )
    {
        BEG( "Expression::keyword( " << peek.value().inspect() << " )" );

        Token token = lexer().nextToken();

        Express* arg1 = new Express();
        expr.push( new Message( *token.value().get<Symbol>(), arg1 ) );

        KeywordExpressionParser( lexer() ).parse( *arg1 );
        
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

    void ExpressionParser::arrow( Express& expr, Token peek )
    {
/*        BEG( "Expression::arrow()" );
        cout << "arrow" << endl;

        lexer().nextToken();

        Express* blockExpr = new Express();
        Create* block = new Create( blockExpr );
        expr.push( block );

        ExpressionParser( lexer() ).parse( *blockExpr );

        END( "Arrow" );*/
    }

 //
 // class KeywordExpressionParser
 //

    void KeywordExpressionParser::initialize( Express& expr, Token peek )
    {
        BEG( "BinaryExpression::initialize()" );
    }

    void KeywordExpressionParser::finalize( Express& expr, Token peek )
    {
        END( "BinaryExpression::finalize()" );
    }
    
 //
 // SubexprExpressionParser
 //

    void SubexprExpressionParser::initialize( Express& expr, Token peek )
    {
        BEG( "SubExpression::initialize()" );
    }

    void SubexprExpressionParser::finalize( Express& expr, Token peek )
    {
        END( "SubExpression::finalize()" );
    }

} }

