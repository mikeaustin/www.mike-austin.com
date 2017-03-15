//
// protos/message.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_MESSAGE_H_
#define _IMPULSE_MESSAGE_H_

#include "../impulse.h"

namespace impulse {

 //
 // class Message
 //

 ///
 /// A Message simply stores a selector and arguments.  When eval()'d, it evaluates each argument
 /// and call's the receiver's send() method with the evaluated args.
 ///

    class Message : public Frame {

     public:

		Message( Symbol& selector ) : _selector( selector ) { }
		Message( Symbol& selector, Value arg1 ) : _selector( selector ), _args( arg1 ) {  }
		Message( Symbol& selector, Value arg1, Value arg2 ) : _selector( selector ), _args( arg1, arg2 ) {  }

        Value eval( Array& args, Value self );

        Value evaluate( Array& args, Value self, Value context );

        string inspect() { return "[Message]"; }

     private:

        Symbol& _selector;
        Array   _args;

    };

 //
 // class Assign
 //

    class Assign : public Frame {
    
     public:
     
        Assign( Symbol& symbol, Express& expr ) : _symbol( symbol ), _expr( expr ) { }
     
        Value eval( Array& args, Value self )
        {
            Value context = args.at(0);
            Array margs;

            return self.setSlot( _symbol, _expr.eval( margs, context ) );
        }    

     private:

        Symbol&  _symbol;     
        Express& _expr;
    
    };

 //
 // class Message
 //

    Value Message::eval( Array& args, Value self )
    {
        BEG( "Message::eval( self = " << self.inspect() << " )" );

        Value context = args.at(0);

        Array sendArgs( _args.size() );
        for (unsigned int i = 0; i < _args.size(); i++)
        {
            sendArgs.atPut( i, _args.at(i).eval( args, context ) );
        }

        Value result = self.send( _selector, sendArgs );

        END( result.inspect() );

        return result;
    }

}

#endif
