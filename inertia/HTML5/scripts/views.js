/*
** inertia/scripts/views.js
*/

inertia.View = {
	type: "view",
	
	init: function( element )
	{
		this.element  = element;
		this.subviews = [];
		console.log( element.getAttribute( "type" ) );
		//element.setAttribute( "object", this );
	},

	containsPoint: function( x, y )
	{
		return x > 0 && x < this.element.offsetWidth
			&& y > 0 && y < this.element.offsetHeight;
	},

	addSubview: function( subview )
	{
		subview.parent = this;

		this.subviews.push( subview );
	},

	screenX: function()
	{
		return this.parent.screenX() + this.element.offsetLeft;
	},

	screenY: function()
	{
		return this.parent.screenY() + this.element.offsetTop;
	},

	sendEvent: function( event )
	{
		return event.dispatch( this );
	},

	handleEvent: function( event )
	{
		this[event.type]( event.x, event.y );
		//this[event.type].call( this, event.x, event.y );
	},

	mouseDown: function( x, y )
	{
		console.log( "[" + this.type + "] mouseDown: " + x + ", " + y );
	},

	mouseUp: function( x, y )
	{
		console.log( "[" + this.type + "] mouseUp: " + x + ", " + y );
	},

	mouseDrag: function( x, y )
	{
		console.log( "[" + this.type + "] mouseDrag: " + x + ", " + y );
	}
}.extend( Object );

inertia.Desktop = {
	type: "desktop",
	
	init: function( element )
	{
		inertia.View.prototype.init.call( this, element );
	},
	
	screenX: function()
	{
		return 0;
	},

	screenY: function()
	{
		return 0;
	},
	
	sendEvent: function( event )
	{
		if (this.grabbed)
		{
			var view = this.grabbed;

			var grabbedEvent = new inertia.MouseEvent( event.type, event.x - view.screenX(), event.y - view.screenY() );
		
			view.handleEvent( grabbedEvent );
		
			if (event.type == "mouseUp")
				this.grabbed = null;
		
			return view;
		}
		else if (event.type == "mouseDown")
		{
			var view = this.supertype.sendEvent.call( this, event );
		
			this.grabbed = view;
		
			return view;
		}
		else
		{
			var view = this.supertype.sendEvent.call( this, event );
		
			return view;
		}
	},

	newDocument: function( event )
	{
		alert( "You want a new document?  Get your own!" );
	},
	
	printDocument: function( event )
	{
		alert( "Sorry, this is just a prototype, buddy!" );
	}
}.extend( inertia.View );

inertia.Dialog = {
	type: "dialog",
	
	init: function( element )
	{
		inertia.View.prototype.init.call( this, element );
	}
}.extend( inertia.View );

inertia.Button = {
	type: "button",
	
	init: function( element )
	{
		inertia.View.prototype.init.call( this, element );
	},
	
	mouseDown: function( x, y )
	{
		this.supertype.mouseDown.call( this, x, y );
	},
	
	mouseUp: function( x, y )
	{
		this.supertype.mouseUp.call( this, x, y );
		
		var action = this.element.getAttribute( "action" );
		var value  = this.element.getAttribute( "value" );

		if (this.controller && this.controller[action])
		{
			this.controller[action]( value );
		}
	}
}.extend( inertia.View );

inertia.Handle = {
	type: "handle",
	
	init: function( element )
	{
		inertia.View.prototype.init.call( this, element );
		
		firstX = 0;
	},
	
	mouseDown: function( x, y )
	{
		this.firstX = x;
		this.firstY = y;
		
		this.parent.element.style.webkitBoxShadow = "none";
	},
	
	mouseDrag: function( x, y )
	{
		this.parent.element.style.left = this.parent.element.offsetLeft + (x - this.firstX) + "px";
		this.parent.element.style.top  = this.parent.element.offsetTop  + (y - this.firstY) + "px";
	},
	
	mouseUp: function( x, y )
	{
		this.parent.element.style.webkitBoxShadow = "";
	}
}.extend( inertia.View );
