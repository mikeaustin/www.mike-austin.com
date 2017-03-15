#include <iostream>
#include <string>
#include <cstring>
#include <cstdlib>

using namespace std;

class Token {

 public:

    enum Type { Nil, Number, Operator, Identifier, Terminator };

    Token()                          : _type( Nil ) { }
    Token( Type type, string value ) : _type( type ), _value( value ) { }

    Type& type() { return _type; }
    string value() { return _value; }

    Type   _type;
    string _value;

};


class Lexer {

 public:

    Lexer() : _stream( cin ) { }

    Token nextToken()
    {
        if (_token.type() != Token::Nil)
        {
            Token token   = _token;
            _token.type() = Token::Nil;

            return token;
        }

        while( _stream.peek() == ' ' ) _stream.get();

        long c = _stream.peek(); memset( _buffer, 0, 256 );

        if (isdigit( c ))   return readNumber();
        if (isalpha( c ))   return readIdentifier();
        if (c == '+')       return readOperator();
        if (c == 10)        return Token( Token::Terminator, "<end>" );

        return Token( Token::Nil, "nil" );
    }

    Token peekToken()
    {
        if (_token.type() != Token::Nil) return _token;

        return _token = nextToken();
    }

    Token readNumber()
    {
        unsigned int i = 0;

        while (isdigit( _stream.peek() ))
        {
            _buffer[i++] = _stream.get();
        }

        return Token( Token::Number, _buffer );
    }

    Token readIdentifier()
    {
        unsigned int i = 0;

        while (isalpha( _stream.peek() ))
        {
            _buffer[i++] = _stream.get();
        }

        return Token( Token::Identifier, _buffer );
    }

    Token readOperator()
    {
        _buffer[0] = _stream.get();

        return Token( Token::Operator, _buffer );
    }

    istream& _stream;
    char     _buffer[256];
    Token    _token;

};


class Parser {

 public:

    Parser( Lexer lexer ) : _lexer( lexer ) { }

    void expression()
    {
        cout << "expression()" << endl;

        Token peek = _lexer.peekToken();

        if (peek.type() == Token::Number)
        {
            number();
        }
        else if (peek.type() == Token::Identifier)
        {
            identifier();
        }

        if (_lexer.peekToken().type() != Token::Terminator)
        {
            throw string( "Unexpected token: " ) + _lexer.peekToken().value();
        }
    }

    void number()
    {
        cout << "number()" << endl;

        _lexer.nextToken();

        Token peek = _lexer.peekToken();

        message();
    }

    void identifier()
    {
        cout << "identifier()" << endl;

        _lexer.nextToken();

        message();
    }

    void message()
    {
        Token peek = _lexer.peekToken();

        if (peek.type() == Token::Operator)
        {
            operatorx();
        }
        else if (peek.type() == Token::Identifier)
        {
            identifier();
        }
    }

    void binary_expression()
    {
        cout << "expression()" << endl;

        Token peek = _lexer.peekToken();

        if (peek.type() == Token::Number)
        {
            number();
        }
        else if (peek.type() == Token::Identifier)
        {
            identifier();
        }
        else
        {
            throw string( "Expected expression " );
        }

        if (_lexer.peekToken().type() != Token::Terminator)
        {
            throw string( "Unexpected token: " ) + _lexer.peekToken().value();
        }
    }

    void operatorx()
    {
        cout << "operator()" << endl;

        _lexer.nextToken();

        binary_expression();
    }

    Lexer _lexer;

};


int main( int argc, char* argv[] )
{
    Lexer lexer;

    try
    {
        Parser( lexer ).expression();
    }
    catch( string error )
    {
        cout << error << endl;
    }

    return 0;
}
