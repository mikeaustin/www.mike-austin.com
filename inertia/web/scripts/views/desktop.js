function Desktop() { }

Desktop.prototype = new View();

Desktop.prototype.init = function( element )
{
	this.constructor.prototype.init.call( this, element );
	
	this._grabbed = null;
	
	return this;
}

Desktop.prototype.screenX = function()
{
	return 0;
}

Desktop.prototype.screenY = function()
{
	return 0;
}

Desktop.prototype.sendEvent = function( event )
{
	if (this._grabbed)
	{
		var view = this._grabbed;

		var grabbedEvent = new inertia.MouseEvent( event.type, event.x - view.screenX(), event.y - view.screenY() );
		
		view.handleEvent( grabbedEvent );
		
		if (event.type == "onMouseUp")
			this._grabbed = null;
		
		return view;
	}
	else if (event.type == "onMouseDown")
	{
		var view = this.constructor.prototype.sendEvent.call( this, event );
		
		this._grabbed = view;
		
		return view;
	}
	else
	{
		var view = this.constructor.prototype.sendEvent.call( this, event );
		
		return view;
	}
}



Object.prototype.extend = function( proto )
{
	var object = function()
	{
		this.init.apply( this, arguments );
	};
	
	object.prototype = new proto();
	object.constructor = object;
	
	for (method in this)
	{
		object[method] = this[method];
	}
	
	return object;
}

inertia.Button = {
	onMouseDown: function( x, y )
	{
	}
}.extend( View );


var button = new inertia.Button();
console.log(button.element);
