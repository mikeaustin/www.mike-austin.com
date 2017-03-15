#include <iostream>

using namespace std;

class Frame;

class Value {

 public:

    Value();
    Value( Value const& other );
    Value( Frame* value );
	~Value();

    Frame* getFrame() { return _frame; }

    Value& operator =( Value const& other );
    Value& operator =( Frame* frame );

 private:

    Frame* _frame;

};


class Frame
{

 public:

    Frame() : _refCount( 0 ) { }

    void incr() { cout << "incr() " << this << ": " << ++_refCount << endl; }
    void decr() { cout << "decr() " << this << ": " << --_refCount << endl; }

 private:

    int _refCount;

    friend class Value;

};

Frame* NilFrame = new Frame();
Value Nil, Float;

Value::Value() : _frame( NULL ) { }

Value::Value( Value const& value ) : _frame( value._frame )
{
    cout << "Value::Value( Value other& other )" << endl;

    _frame->incr();
}

Value::Value( Frame* value ) : _frame( value )
{
    cout << "Value::Value( Frame* )" << endl; _frame->incr();
}

Value::~Value()
{
    cout << "Value::~Value() " << _frame << endl;

    if (!_frame) return;

    _frame->decr();

    if (_frame->_refCount == 0)
    {
        cout << "delete " << _frame << endl;
        delete _frame;
    }
}

Value& Value::operator =( Value const& other )
{
    cout << "Value::operator =( Value other ) " << _frame << endl;

    if (_frame) _frame->decr();

    _frame = other._frame;
    _frame->incr();
    
    return *this;
}

Value& Value::operator =( Frame* frame )
{
    cout << "Value::operator =( Frame* frame ) " << _frame << endl;

    if (_frame) _frame->decr();

    _frame = frame;
    _frame->incr();
    
    return *this;
}


int main( int argc, char* argv[] )
{
	cout << "-- 1 -------------------------------------------------------" << endl;
    Nil = new Frame();
	cout << "-- 2 -------------------------------------------------------" << endl;
    Value val = new Frame();
	cout << "-- 3 -------------------------------------------------------" << endl;
    Value val2 = val;
	cout << "-- 4 -------------------------------------------------------" << endl;

    return 0;
}

