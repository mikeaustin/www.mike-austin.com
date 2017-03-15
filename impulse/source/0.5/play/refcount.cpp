#include <iostream>

using namespace std;

class Frame;

class Value
{

 public:

    Value();
    Value( Frame* value );
	~Value();

    Frame* getFrame() { return _frame; }

    Value& operator =( Value other );

 private:

    Frame* _frame;

};


class Frame
{

 public:

    Frame() : _refCount( 0 ) { }

    void incr()
    {
        cout << this << ": " << ++_refCount << endl;
    }

    void decr()
    {
        cout << this << ": " << --_refCount << endl;
    }

 private:

    int _refCount;

    friend class Value;

};


Value Nil, Float;

Value::Value() : _frame( Nil.getFrame() ) { }

Value::Value( Frame* value ) : _frame( value )
{
    _frame->incr(); cout << "Value::Value( Frame* )" << endl;
}

Value::~Value()
{
    _frame->decr();
    cout << "Value::~Value() " << _frame << endl;
    if (_frame->_refCount == 0)
    {
        cout << "delete " << _frame << endl;
        delete _frame;
    }
}

Value& Value::operator =( Value other )
{
    if (_frame) _frame->decr();
    _frame = other._frame;
    _frame->incr();
}


int main( int argc, char* argv[] )
{
    Nil = new Frame();
    Float = new Frame();

	cout << "------------------------------------------------------------" << endl;

    return 0;
}

