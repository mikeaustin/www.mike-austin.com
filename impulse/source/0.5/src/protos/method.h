//
// protos/method.h
//
// Copyright (c) 2008-2009, Mike Austin
// All rights reserved.
//

#ifndef _IMPULSE_METHOD_H_
#define _IMPULSE_METHOD_H_

#include "array.h"

namespace impulse {

 //
 // class Method
 //

 ///
 /// A Method is a wrapper around a C++ method to be used as a slot value.  Calling eval()
 /// invokes the method, throwing an exception if argument types are given and not matched.
 ///

	template <typename T>
    class Method : public Frame {

     public:

     // Constructors

		Method(string name, Value (T::*method)(Array&, Value)) : _method( method ) { }
		Method(string name, Value (T::*method)(Array&, Value), Frame* arg1proto) : _method( method )
        {
            //_methods[arg1proto] = new Method<T>( name, method );
            _signature.push( arg1proto );
        }

     // Runtime overrides

        Value eval( Array& args, Value self );

        string inspect() { return "[Method]"; }

     // Native methods

        Value invoke( Value proto, Array& args, Value self )
        {
            T* frame = proto.get<T>();

            if (frame)
                return ((proto.get<T>())->*_method)( args, self );
            else
                throw string( "Invalid frame subclass for method" );
        }

     private:

		Value (T::*_method)(Array&, Value);
        Array  _signature;
        //map<Frame*, Method*> _methods;

    };

 //
 // class Method
 //

	template <typename T>
    Value Method<T>::eval( Array& args, Value self )
    {
        BEG( "Method::eval( args" << ", self = " << self.inspect() << " )" );

        Value proto = args.at(0);
        //Array& margs = *args.at(1).get<Array>();
        Array& margs = *args.at(1).template get<Array>(); // Needed for GCC 4.0.1

        //trace << &(spaces[60 - indent]) << "proto = " << args.at(0).inspect() << endl;

        //cout << "Method::eval( proto = " << proto.getFrame()
        //     << ", margs = " << &margs << " )" << endl;

        Value result;

        for (unsigned int i = 0; i < _signature.size(); i++)
        {
            if (margs.at(i).getFrame() != _signature.at(i).getFrame())
            {
                cout << "** Argument types do not match method signature" << endl;

                return _nil_;
            }
        }

        result = invoke( proto, margs, self );

/*
        Method* method = this;
        Value result;

        for (int i = 0; method->_methods.find( margs.at(i).getFrame() ) != method->_methods.end(); i++)
        {
            method = method->_methods[margs.at(i).getFrame()];
        }

        if (method->_method)
        {
            result = method->invoke( proto, margs, self );
        }
        else
        {
            throw "No applicable method found for argument " + margs.at(0).inspect();
        }
*/

        END( result.inspect() );

        return result;
    }

}

#endif
