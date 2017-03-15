if (!window.console)
	window.console = { log: function() { } };

var inertia = { };


var desktop = null;
var event = null;

HTMLDocument.prototype.$ = function( selector )
{
	return this.querySelector( selector );
}

HTMLElement.prototype.$ = function( selector )
{
	return this.querySelector( selector );
}

HTMLElement.prototype.$$ = function( selector )
{
	return this.querySelectorAll( selector );
}

HTMLElement.prototype.load = function( url )
{
	new Request( url ).send( {updateElement: this} );
	
	return this;
}

HTMLElement.prototype.show = function()
{
	this.style.display = "block";
	
	return this;
}

// ---------------------------------------------------------------------------------------------- //

function Request( url )
{
	this.request = new XMLHttpRequest();
	this.request.open( "GET", url );
}

Request.prototype.send = function( options )
{
	var self = this;
	
	this.request.onreadystatechange = function()
	{
		if (this.readyState == 4 && this.status == 200)
		{
			if (options.updateElement)
				options.updateElement.innerHTML = this.responseText;
			if (options.onComplete)
				options.onComplete( this );
		}
	}
	
	this.request.send();
}

function List( element ) { }

List.prototype = new View();

List.prototype.init = function( element )
{
	this.constructor.prototype.init.call( this, element );

	return this;
}

List.prototype.refresh = function( dataArray )
{
	var template = document.$( "#template" );
	this.element.innerHTML = "";

	for (var i = 0; i < dataArray.length; i++)
	{
		var row = template.cloneNode( true );

		for (var field in dataArray[i])
		{
			var element = row.querySelector( "[rel='" + field + "']" );
			if (!element) continue;
			
			if (dataArray[i][field] instanceof Date)
				element.innerHTML = dataArray[i][field].toString().match( /[\w]* [\w]* [\d]* [\w]*/ );
			else
				element.innerHTML = dataArray[i][field];
		}

		this.element.appendChild( row );
	}
}

List.prototype.load = function( url )
{
	var self = this;
	
	new Request( url ).send(
	{
		onComplete: function( request )
		{
			self.refresh( eval( request.responseText ) );
		}
	});
}

// ---------------------------------------------------------------------------------------------- //

function sendScreenEvent( event, type )
{
	window.event = event;
	
	//event.preventDefault();
	//event.stopPropagation();

	if (event.touches)
	{
		event.clientX = event.touches[0].clientX;
		event.clientY = event.touches[0].clientY;
	}

	desktop.sendEvent( new inertia.MouseEvent( type, event.clientX, event.clientY ) );
}


//function Event() { }

inertia.MouseEvent = function( type, x, y )
{
	this.type = type;
	this.x    = x;
	this.y    = y;
}

//MouseEvent.prototype = new Event();

inertia.MouseEvent.prototype.dispatch = function( view )
{
	var subviews = view.subviews;

	for (var i = subviews.length - 1, subview = subviews[i]; i >= 0; subview = subviews[--i]) {
		if (i < 0) break;
		
		var subviewX = this.x - subview.element.offsetLeft;
		var subviewY = this.y - subview.element.offsetTop;

		if (subview.containsPoint( subviewX, subviewY )) {
			var event = new inertia.MouseEvent( this.type, subviewX, subviewY );

			return subview.sendEvent( event );
		}
	}

	view.handleEvent( this );
	
	return view;
}

// --------------------------------------------------------------------------------

function View() { }

//View.create = function( element )
//{
//	var self = new this().init( element );
//}

View.prototype.init = function( element )
{
	//console.log( "View.init()" );
	
	this.element  = element;
	this.subviews = [];
	
	return this;
}

View.NORMAL  = 0;
View.PRESSED = 1;

View.prototype.addSubview = function( subview )
{
	subview.parent = this;
	
	this.subviews.push( subview );

	for (var i = 0, subview = this.subviews[i]; i < this.subviews.length; subview = this.subviews[++i])
	{
		subview.element.style.zIndex = i;
	}

}

View.prototype.removeSubview = function( subview )
{
	subview.parent = null;
	
	this.subviews.splice( this.subviews.indexOf( subview ), 1 );
}

View.prototype.containsPoint = function( x, y )
{
	return x > 0 && x < this.element.offsetWidth
		&& y > 0 && y < this.element.offsetHeight;
}

View.prototype.screenX = function()
{
	return this.parent.screenX() + this.element.offsetLeft;
}

View.prototype.screenY = function()
{
	return this.parent.screenY() + this.element.offsetTop;
}

View.prototype.sendEvent = function( event )
{
	return event.dispatch( this );
}

View.prototype.handleEvent = function( event )
{
	this[event.type]( event.x, event.y );
}

View.prototype.onMouseDown = function( x, y )
{
	//console.log( "onMouseDown: " + x + ", " + y );
}

View.prototype.onMouseMove = function( x, y )
{
	//console.log( "onMouseMove: " + x + ", " + y );
}

View.prototype.onMouseUp = function( x, y )
{
	//console.log( "onMouseMove: " + x + ", " + y );
}
