/*
** inertia/scripts/core.js
*/

if (!window.console)
{
	window.console = { log: function() { } };
}

Document.prototype.$ = function( selector )
{
	return this.querySelector( selector );
}

Element.prototype.$ = function( selector )
{
	return this.querySelector( selector );
}

Document.prototype.$$ = function( selector )
{
	return this.querySelectorAll( selector );
}

var inertia = { };

inertia.MouseEvent = function( type, x, y )
{
	this.type = type;
	this.x    = x;
	this.y    = y;
};

inertia.MouseEvent.prototype.dispatch = function( view )
{
	var subviews = view.subviews;

	for (var i = subviews.length - 1, subview = subviews[i]; i >= 0; --i) {
		var subview = subviews[i];

		var x = this.x - subview.element.offsetLeft;
		var y = this.y - subview.element.offsetTop;

		if (subview.containsPoint( x, y ))
		{
			var event = new inertia.MouseEvent( this.type, x, y );

			return subview.sendEvent( event );
		}
	}

	view.handleEvent( this );

	return view;
};


Object.prototype.extend = function( supertype )
{
	var object = function()
	{
		if (arguments.length != 0)
			this.init.apply( this, arguments );
	};
	
	object.prototype = new supertype();
	object.prototype.constructor = object;
	object.prototype.supertype = supertype.prototype;
	
	for (property in this)
	{
		object.prototype[property] = this[property];
	}
	
	return object;
}

function injectTypes( controller, parent, element )
{
	//if (parent.element != element)
	{
		var type = element.getAttribute( "type" ) || element.nodeName.toLowerCase();
		var rel  = element.getAttribute( "rel" );
		
		for (property in inertia)
		{
			if (inertia[property].prototype["type"] == type)
			{
				var view = new inertia[property]( element );
	
				view.controller = controller;
				parent.addSubview( view );

				if (parent.element != element)
				{
					parent = view;
				}
				
				if (rel == "controller")
				{
					controller = view;
				}
			}
		}
	}
	
	var nodes = element.childNodes;
	
	for (var i = 0, child = nodes[i]; i < nodes.length; child = nodes[++i])
	{
		if (child.nodeType != 1) continue;

		injectTypes( controller, parent, child );
	}
}

inertia.Controller = {
	type: "controller"
}.extend( Object );

var desktop = null;
var button = null;

document.addEventListener( "mousedown", function( event )
{
	button = event.button;

	event.preventDefault();
	event.stopPropagation();

	var event = new inertia.MouseEvent( "mouseDown", event.clientX, event.clientY );

	desktop.sendEvent( event );
}, false );

document.addEventListener( "mouseup", function( event )
{
	button = null;
	
	event.preventDefault();
	event.stopPropagation();

	var event = new inertia.MouseEvent( "mouseUp", event.clientX, event.clientY );

	desktop.sendEvent( event );
}, false );

document.addEventListener( "mousemove", function( event )
{
	event.preventDefault();
	event.stopPropagation();

	if (button != null)
	{
		event = new inertia.MouseEvent( "mouseDrag", event.clientX, event.clientY );
		
		desktop.sendEvent( event );
	}
}, false );

window.addEventListener( "load", function( event )
{
	desktop = new inertia.Desktop( document.$( "#desktop" ) );

	injectTypes( null, desktop, desktop.element );
}, false );
