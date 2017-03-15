function Titlebar() { }

Titlebar.prototype = new View();

Titlebar.prototype.onMouseDown = function( x, y )
{
	event.preventDefault();
	event.stopPropagation();

	this.state = View.PRESSED;
	
	this.firstX = x;
	this.firstY = y;
	
	this.lastX = x;
	this.lastY = y;
}

Titlebar.prototype.onMouseMove = function( x, y )
{
	if (this.state != View.PRESSED) return;
	
	//console.log( "onMouseMove: " + x + ", " + y );
	var deltaX = x - this.lastX;
	var deltaY = y - this.lastY;
	
	this.element.parentNode.style.left = this.element.parentNode.offsetLeft + deltaX + "px";
	this.element.parentNode.style.top  = this.element.parentNode.offsetTop  + deltaY + "px";
	
	this.lastX = x - deltaX;
	this.lastY = y - deltaY;
}

Titlebar.prototype.onMouseUp = function( x, y )
{
	this.state = View.NORMAL;
}

// --------------------------------------------------------------------------------

function Sizer() { }

Sizer.prototype = new View();

Sizer.prototype.onMouseDown = function( x, y )
{
	event.preventDefault();
	event.stopPropagation();

	this.state = View.PRESSED;

	this.lastX = x;
	this.lastY = y;
}

Sizer.prototype.onMouseMove = function( x, y )
{
	if (this.state != View.PRESSED) return;

	var deltaX = x - this.lastX;
	var deltaY = y - this.lastY;

	this.element.parentNode.style.width  = this.element.parentNode.offsetWidth - 2 + deltaX + "px";
	this.element.parentNode.style.height = this.element.parentNode.offsetHeight - 2 + deltaY + "px";
	
	this.lastX = x - deltaX;
	this.lastY = y - deltaY;
}

Sizer.prototype.onMouseUp = function( x, y )
{
	this.state = View.NORMAL;
}

// --------------------------------------------------------------------------------

function Window() { }

Window.prototype = new View();

Window.prototype.init = function( element )
{
	this.constructor.prototype.init.call( this, element );
	
	var header = this.element.querySelector( ".titlebar" );
	this.addSubview( new Titlebar().init( header ) );

	var sizer = this.element.querySelector( ".sizer" );
	if (sizer)
		this.addSubview( new Sizer().init( sizer ) );
	
	return this;
}

Window.prototype.sendEvent = function( event )
{
	if (event.type == "onMouseDown")
	{
		var parent = this.parent;
		
		parent.removeSubview( this );
		parent.addSubview( this );
	}
	
	return this.constructor.prototype.sendEvent.call( this, event );
}
