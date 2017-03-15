namespace impulse { namespace parser {

 //
 // class Lexer
 //

    Token Lexer::readNumber()
    {
        if (!isdigit( _stream.peek() )) return Token( &Parser::nil, _nil_ );

        long i = 0;

        while (isdigit( _stream.peek() ))
        {
            _buffer[i++] = _stream.getc();
        }

        if (_stream.peek() == '.')
        {
            _stream.getc();
            
            if (_stream.peek() == '.')
            {
                _stream.unget( '.' );

				return Token( &Parser::number, atof( _buffer ) );
		    }
		    else if (isdigit( _stream.peek() ))
		    {
                _buffer[i++] = '.';
                
			    while (isdigit( _stream.peek() ))
			    {
				    _buffer[i++] = _stream.getc();
			    }
		    }
		    else return Token( &Parser::nil, _nil_ );
        }

        return Token( &Parser::number, atof( _buffer ) );
    }

    Token Lexer::readString()
    {
        if (_stream.peek() != '"') return Token( &Parser::nil, _nil_ );

        _stream.getc();

        long i = 0;

        while (_stream.peek() != '"')
        {
            _buffer[i++] = _stream.getc();
        }

        _stream.getc();

        return Token( &Parser::stringx, new String( _buffer ) );
    }

    Token Lexer::readOperator()
    {
        const static string operators = "+-*/.,<>@";
        int c = _stream.peek();

        if (operators.find_first_of( c ) == string::npos)
            return Token( &Parser::nil, _nil_ );

        int i = 0;

        while (c = _stream.peek(), operators.find_first_of( c ) != string::npos)
        {
            _buffer[i++] = _stream.getc();
        }

        //if (_buffer[0] == '.' && _buffer[1] == '.')
        //    return Token( &Parser::range, &Symbol::at( _buffer ) );
        if (_buffer[0] == '-' && _buffer[1] == '>')
            return Token( &Parser::arrow, &Symbol::at( _buffer ) );
        else
            return Token( &Parser::operatorx, &Symbol::at( _buffer ) );
    }

    Token Lexer::readIdentifier()
    {
        if (!isalpha( _stream.peek() )) return Token( &Parser::nil, _nil_ );

        long i = 0;

        while (isalpha( _stream.peek() ) || _stream.peek() == '-')
        {
            _buffer[i++] = _stream.getc();
        }

        if (_stream.peek() == ':')
        {
            _buffer[i] = _stream.getc();
            
            return Token( &Parser::keyword, &Symbol::at( _buffer ) );
        }

        return Token( &Parser::identifier, &Symbol::at( _buffer ) );
    }

    Token Lexer::readSubexpr()
    {
        long c = _stream.peek();

        if (c != '(' && c != ')') return Token( &Parser::nil, _nil_ );

        _buffer[0] = _stream.getc();

        if (c == '(')
            return Token( &Parser::openexpr, &Symbol::at( _buffer ) );
        else
            return Token( &Parser::closeexpr, &Symbol::at( _buffer ) );
    }

    Token Lexer::readAssign()
    {
        if ( _stream.peek() != '=' ) return Token( &Parser::nil, _nil_ );

        _buffer[0] = _stream.getc();

        return Token( &Parser::assign, &Symbol::at( _buffer ) );
    }

    Token Lexer::readTerminator()
    {
        if ( _stream.peek() != 10 && _stream.peek() != EOF ) return Token( &Parser::nil, _nil_ );

        int c = _stream.getc();

        if (c == 10)
            return Token( &Parser::terminator, &Symbol::at( "[terminator]") );
        else if (c == EOF)
            return Token( &Parser::endstream, &Symbol::at( "[endstream]") );
        else
            return Token( &Parser::nil, _nil_ );
    }

    Token Lexer::readComment()
    {
        if (_stream.peek() != '#') return Token( &Parser::nil, _nil_ );
        
        int i = 0;

        while (_stream.peek() != 10)
        {
            _buffer[i++] = _stream.getc();
        }

        return Token( &Parser::nil, &Symbol::at( _buffer ) );
    }

} }

