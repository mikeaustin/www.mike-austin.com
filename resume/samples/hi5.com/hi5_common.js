//
// Common hi5 fuctions
//

//
// Example:
//
// $id('email').innerHTML = 'Hello, World!';
//

/*
 *  Returns an element with the id of element_id
*/

var $id = function(element_id) {
	return document.getElementById(element_id);
}

/*
 *  Returns an array of elements of type tagname, optionally filtered by classname
*/

var $tag = function(tagname, opt_classname) {
	var elements = document.getElementsByTagName(tagname);

	if (!opt_classname) {
		return elements;
	}

	var filtered = [];

	for (var i = 0; i < elements.length; i++) {
		if (elements[i].className.toLowerCase() == opt_classname) {
			filtered.push(elements[i]);
		}
	}

	return filtered;
}

//
//
//

var hi5 = window.hi5 || {};

/* ---------------------------------------------------------------------------------------------------- *\
 *																										*
 *  hi5.util																							*
 *																										*
\* ---------------------------------------------------------------------------------------------------- */

hi5.util = {};

/*
 *  Get the absolute position of an element, returning {left, top}
*/

hi5.util.position = function(element) {
	var left = element.offsetLeft;
	var top = element.offsetTop;

	while (element = element.offsetParent) {
		left += element.offsetLeft + (element.clientLeft || 0);
		top += element.offsetTop + (element.clientTop || 0);
	}

	return { left: left, top: top };
}

/*
 *  Show an element, optionally passing an effect to use
*/

hi5.util.show = function(element, effect) {
	clearInterval(hi5.effect._fadeTimer);

	element.style.opacity = '';
	element.style.filter = '';

	(effect ? effect : hi5.effect.show)(element);
}

/*
 *  Hide an element, optionally passing an effect to use
*/

hi5.util.hide = function(element, effect) {
	clearInterval(hi5.effect._fadeTimer);

	element.style.opacity = '';
	element.style.filter = '';

	(effect ? effect : hi5.effect.hide)(element);
}

/*
 *  Build a DOM element by tag name, with attributes and children
*/

hi5.util.build = function(tagname, attributes, children) {
	var element = document.createElement(tagname);

	for (attr in attributes) {
		element.setAttribute(attr, attributes[attr]);
	}

	if (!children) return element;

	for (var i = 0; i < children.length; i++) {
		if (typeof children[i] == 'string')
			element.appendChild(document.createTextNode(children[i]));
		else
			element.appendChild(children[i]);
	}

	return element;
}

/*
 *  Attach an event listener function to an element
*/

hi5.util.attach = function(element, event, functionx) {
	if (element.addEventListener)
		element.addEventListener(event, functionx, false);
	else if (element.attachEvent)
		element.attachEvent('on' + event, functionx);
}

/* ---------------------------------------------------------------------------------------------------- *\
 *																										*
 *   hi5.effect																							*
 *																										*
\* ---------------------------------------------------------------------------------------------------- */

hi5.effect = {};

hi5.effect.show = function(element) {
	element.style.display = '';
}

hi5.effect.hide = function(element) {
	element.style.display = 'none';
}

/*
 *  Fades the element and hides it.  Roughly fades in about .5 seconds.
*/

hi5.effect.fade = function(element) {
	if (!element.style.opacity)
		element.style.opacity = 1;

	hi5.effect._fadeTimer = setInterval(function() {
		if (element.style.opacity > 0) {
			element.style.opacity -= 0.025;
			element.style.filter = 'alpha(opacity=' + element.style.opacity * 100 + ')';
		} else {
			hi5.util.hide(element);
		}
	}, 10);
}

/* ---------------------------------------------------------------------------------------------------- *\
 *																										*
 *   hi5.core																							*
 *																										*
\* ---------------------------------------------------------------------------------------------------- */

hi5.core = {};

/*
 *  Simple Ajax request object.  Note: does not support inline styles or Javascript.
 *
 *	Example:
 *
 *	hi5.Request('http://www.hi5.com', {
 *		onComplete: function(response) {
 *			alert(response.responseText);
 *		}
 *	}).send('my-div');
*/

hi5.core.Request = function(ajaxURL, options) {
	this.ajaxURL = ajaxURL;

	if (window.ActiveXObject) {
		this.request = new ActiveXObject("Microsoft.XMLHTTP");
	} else if (window.XMLHttpRequest) {
		this.request = new XMLHttpRequest();
	}

	for (option in options) {
		switch (option) {
			case 'onComplete':
				this.onComplete = options[option];
			break;
		}
	}

	var self = this;

	this.request.onreadystatechange = function() {
		if (self.request.readyState == 4) {
			if (self.updateElement) {
				$id(self.updateElement).innerHTML = self.request.responseText;
				delete self.updateElement;
			}
			if (self.onComplete) {
				self.onComplete(self.request);
			}
		}
	}
}

hi5.core.Request.prototype.send = function(options) {
	this.request.open('get', this.ajaxURL, true);

	for (option in options) {
		switch (option) {
			case 'updateElement':
				this.updateElement = options[option];
			break;
			case 'onComplete':
				this.onComplete = options[option];
			break;
		}
	}

	this.request.send(null);
}

/* ---------------------------------------------------------------------------------------------------- *\
 *																										*
 *   hi5.widget																							*
 *																										*
\* ---------------------------------------------------------------------------------------------------- */

hi5.widget = {};

/*
 *	Grays out the window and pops open a lightbox.  If no title given, body uses entire contents of lightbox.
 *
 *	Example:
 *
 *	new hi5.widget.Lightbox(new hi5.core.Request('/friend/browserViewFriendsAJAX.do?offset=11'), {
 *		title: 'Are you sure you want to do that?',
 *		width: 600, onAccept: function() {...}
 *	});
*/

hi5.widget.Lightbox = function(body_or_request, options) {
	var overlay = $id('black-overlay'), iframe = $id('iframe-overlay'),	dialog = $id('dialog-overlay');
	var title, updateElement = 'dialog-border';

	for (option in options) {
		switch (option) {
			case 'width':
				dialog.style.width = options[option] + 'px';
				dialog.style.marginLeft = -options[option] / 2 + 'px';
			break;
			case 'title':
				$id('dialog-title').innerHTML = options[option];
				updateElement = 'dialog-body';
			break;
			case 'acceptText':
				$id('dialog-accept').innerHTML = options[option];
			break;
			case 'onAccept':
				var accept = $id('dialog-accept');
				hi5.util.show(accept);

				accept.callback = options[option];
				accept.onclick = function() {
					this.callback();
					dialog.style.display = iframe.style.display = overlay.style.display = 'none';
				}
			break;
			case 'cancelText':
				$id('dialog-cancel').innerHTML = options[option];
			break;
			case 'onCancel':
				var canel = $id('dialog-cancel');
				hi5.util.show(cancel);

				cancel.callback = options[option];
				cancel.onclick = function() {
					this.callback();
					dialog.style.display = iframe.style.display = overlay.style.display = 'none';
				}
			break;
			case 'styleClass':
				dialog.className = iframe.className = options[option];
			break;
		}
	}

	if (body_or_request.constructor == String) {
		$id(updateElement).innerHTML = body_or_request;
		setTimeout(showLightbox, 0);
	} else if (body_or_request.constructor == hi5.core.Request) {
		body_or_request.send({
			updateElement: updateElement,
			onComplete: showLightbox
		});
	}

	function showLightbox() {
		var scrollTop = 0;

		if (document.documentElement.scrollTop != undefined)
			scrollTop = document.documentElement.scrollTop;
		else if (window.scrollY != undefined)
			scrollTop = window.scrollY;

		dialog.style.display = iframe.style.display = overlay.style.display = 'block';
		dialog.style.marginTop = iframe.style.marginTop = -dialog.offsetHeight / 2 + scrollTop + 'px';
		iframe.style.width = dialog.offsetWidth + 'px'; iframe.style.height = dialog.offsetHeight + 'px';
	}
}

hi5.widget.Lightbox.prototype.close = function() {
	var overlay = $id('black-overlay'), iframe = $id('iframe-overlay'),	dialog = $id('dialog-overlay');
	dialog.style.display = iframe.style.display = overlay.style.display = 'none';
}

/*
 *	Pops up a tooltip/bubble just above the given element, with optional title.
 *
 *	Example:
 *
 *	new hi5.wdiget.Bubble($('email'), 'Invalid email address', {title: 'Error', timeout: 3});
*/

hi5.widget.Bubble = function(element, body_or_request, options) {
	var coords = hi5.util.position(element);
	var updateElement = 'bubble-middle';
	var bubble, middle, iframe, titlex;

	bubble = hi5.util.build('div', {id: 'bubble-overlay'}, [
		hi5.util.build('div', {id: 'bubble-top'}),
		hi5.util.build('div', {id: 'bubble-middle'}, [
			hi5.util.build('h1', {id: 'bubble-title'}),
			hi5.util.build('div', {id: 'bubble-body'})
		]),
		hi5.util.build('div', {id: 'bubble-bottom'})
	]);

	$tag('body')[0].insertBefore(bubble, $tag('body')[0].firstChild);

	var iframe = $id('iframe-overlay')
	var middle = $id('bubble-middle');
	var titlex = $id('bubble-title');

	hi5.util.show(iframe);
	hi5.util.show(bubble);

	for (option in options) {
		switch (option) {
			case 'title':
				titlex.innerHTML = options[option];
				updateElement = 'bubble-body';
			break;
			case 'timeout':
				var timeout = options[option] * 1000;

				hi5.effect._fadeTimer = setTimeout(function() {
					hi5.util.hide(bubble, hi5.effect.fade);
				}, timeout);
			break;
		}
	}

	$id(updateElement).innerHTML = body_or_request;

	bubble.style.left = coords.left + 'px';
	bubble.style.top = coords.top - bubble.offsetHeight + 'px';

	var coords2 = hi5.util.position(middle);

	iframe.style.left = coords2.left + 10 + 'px';
	iframe.style.top = coords2.top + 'px';
	iframe.style.width = middle.offsetWidth - 26 + 'px';
	iframe.style.height = middle.offsetHeight + 'px';
}

/* ---------------------------------------------------------------------------------------------------- *\
 *																										*
 *   Original hi5.Lightbox																				*
 *																										*
\* ---------------------------------------------------------------------------------------------------- */

hi5.Lightbox = function(title, body, options) {
	var overlay = $id('black-overlay'), iframe = $id('iframe-overlay'),	dialog = $id('dialog-overlay');

	$id('dialog-title').innerHTML = title; $id('dialog-body').innerHTML = body;

	for (opt in options) {
		switch (opt) {
			case 'acceptText':
				$id('dialog-accept').innerHTML = options[opt];
			break;
			case 'onAccept':
				var accept = $id('dialog-accept');

				accept.callback = options[opt];
				accept.onclick = function() {
					this.callback();
					dialog.style.display = iframe.style.display = overlay.style.display = 'none';
				}
			break;
			case 'cancelText':
				$id('dialog-cancel').innerHTML = options[opt];
			break;
			case 'onCancel':
				var button = $id('dialog-cancel');

				button.callback = options[opt];
				button.onclick = function() {
					this.callback();
					dialog.style.display = iframe.style.display = overlay.style.display = 'none';
				}
			break;
			case 'styleClass':
				dialog.className = iframe.className = options[opt];
			break;
		}
	}

	setTimeout(function() {
		var scrollTop = 0;

		if (document.documentElement.scrollTop != undefined)
			scrollTop = document.documentElement.scrollTop;
		else if (window.scrollY != undefined)
			scrollTop = window.scrollY;

		dialog.style.display = iframe.style.display = overlay.style.display = 'block';
		dialog.style.marginTop = iframe.style.marginTop = -dialog.offsetHeight / 2 + scrollTop + 'px';
		iframe.style.width = dialog.offsetWidth + 'px'; iframe.style.height = dialog.offsetHeight + 'px';
	}, 0);
}

hi5.Lightbox.prototype.close = function() {
	var overlay = $id('black-overlay'), iframe = $id('iframe-overlay'),	dialog = $id('dialog-overlay');
	dialog.style.display = iframe.style.display = overlay.style.display = 'none';
}
