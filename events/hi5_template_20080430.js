//
// hi5.template - 2008 hi5 Networks
//
// hi5.template is a simple templating engine implemented in JavaScript, with support for custom tags
//

if (!window.hi5) {
	var hi5 = {};
}

hi5.template = {

	name_cache: {},

	Context: function(parent) {
		if (parent) {
			var context = function() {}
			context.prototype = parent;

			return new context();
		} else {
			return this;
		}
	},

	//
	// Clone a DOM node
	//

	clone: function(node, context) {
		if (document.all && node.getAttribute('name')) {
			var element = document.createElement('<' + node.nodeName + ' name="' + node.name + '" ' + '/>');
		} else {
			var element = document.createElement(node.nodeName);
		}

		var attrs = node.attributes;

		for (var j = 0; j < attrs.length; j++) {
			var value = attrs[j].nodeValue;
			value = this.replace(value, context);

			element.setAttribute(attrs[j].nodeName, value);

			if (document.all && attrs[j].nodeName == 'class') {
				element.className = attrs[j].nodeValue;
			}
			if (document.all && attrs[j].nodeName == 'style') {
				element.style.cssText = value;
			}
			if (document.all && attrs[j].nodeName == 'for') {
				element.htmlFor = value;
			}
			if (document.all && attrs[j].nodeName == 'type' && value) {
				if (element.type) element.type = value;
			}
			if (document.all && attrs[j].nodeName.match(/on.*/)) {
				var code = value;
				element[attrs[j].nodeName] = function() { eval(code); }
			}
		}

		return element;
	},

	//
	// Parse a template from a string and convert to an XML DOM
	//

	parse: function(template) {
		var xml;
	
		if (window.ActiveXObject) {
			xml = new ActiveXObject("Microsoft.XMLDOM");
			xml.async = false;
			xml.loadXML(template);
		} else if (window.DOMParser) {
			var parser = new DOMParser();
			xml = parser.parseFromString(template, 'text/xml');
		}
	
		var root = xml.firstChild;
		if (root.nodeType != 1)
			root = root.nextSibling;
		var nodes = root.childNodes;
		for (var i = 0; i < nodes.length; i++) {
			if (nodes[i].nodeType == 1) {
				this.name_cache[nodes[i].getAttribute('name')] = nodes[i];
			}
		}
	
		return xml;
	},

	//
	// Recursively apply the hi5ml template
	//
	
	apply: function(input, output, context) {
		//
		// Handle convenience parameters and check for child nodes
		//

		if (typeof input == 'string') {
			if (this.name_cache[input]) {
				input = this.name_cache[input];
			} else {
				input = this.name_cache[input] = hi5.template.parse(document.getElementById(input).innerHTML);
			}
		}
		if (!input.hasChildNodes()) return;

		if (typeof output == 'string') {
			output = document.getElementById(output);
		}

		if (!context) {
			context = new this.Context();
		}

		//
		// Iterate over the child nodes of this node
		//
	
		var nodes = input.childNodes;

		for (var i = 0; i < nodes.length; i++) {
			if (this.hi5ml_tags.exists(nodes[i].nodeName)) {
				//
				// Custom tag
				//

				this.hi5ml_tags[nodes[i].nodeName](nodes[i], output, context);
			} else if (nodes[i].nodeType == 3 && nodes[i].nodeValue != null) {
				//
				// Text node
				//
	
				var value = nodes[i].nodeValue;
				value = value.replace(/^[\s]+/, '').replace(/[\s]+$/, '');
				value = this.replace(value, context);

				if (value != '') {
					output.appendChild(document.createTextNode(value));
				}
			} else {
				//
				// Element node
				//

				var element = hi5.template.clone(nodes[i], context);
	
				output.appendChild(element);
				this.apply(nodes[i], element, context);
			}
		}
	},
	
	//
	// Replace occurances of ${var} with JavaScript values
	//
	
	regex: new RegExp(/\$\{([^{}]*)\}/),

	replace: function(value, context) {
		var match;
	
		while (match = value.match(this.regex)) {
			if (match != null && match.length > 1) {
				with (context) {
					var string = eval(match[1]);
				}
	
				value = value.replace(this.regex, string);
			}
		}
	
		return value;
	},

	message: function(resource, substitutions) {
		if (!this._prefs) {
			this._prefs = new gadgets.Prefs();
		}

		var message = this._prefs.getMsg(resource);

		return this.replace(message, substitutions);
	}

};


//
// Define custom template tags
//

hi5.template.hi5ml_tags = {

	exists: function(tag_name) {
		for (key in this) {
			if (key == tag_name) return true;
		}

		return false;
	},

	//
	// 'if' conditional
	//

	'if': function(input, output, context) {
		var test = input.getAttribute('test');

		with (context) {
			var value = eval(test);
		}
		if (value) {
			hi5.template.apply(input, output, context);
		}

		context['_if'] = value;
	},

	'else-if': function(input, output, context) {
		if (context['_if'] == false) {
			this['if'](input, output, context);
		}
	},

	'else': function(input, output, context) {
		if (context['_if'] == false) {
			hi5.template.apply(input, output, context);
		}
	},

	//
	// Iteration
	//

	'for-each': function(input, output, context) {
		var variable = input.getAttribute('var');

		with (context) {
			var source = eval(input.getAttribute('source'));
		}

		if (source.constructor == Array) {
			context = new hi5.template.Context(context);
			context.first = function() { return this.index == 0; },
			context.last = function() { return this.index == this.length - 1; }

			context.length = source.length;

			for (var i = 0; i < source.length; i++) {
				context.index = i;
				context[variable] = source[i];
				hi5.template.apply(input, output, context);
			}
		}
	},

	'set': function(input, output, context) {
		var variable = input.getAttribute('var');
		var buffer = document.createElement('div');
	
		hi5.template.apply(input, buffer, context);
		context[variable] = buffer.innerHTML;
	},

	//
	// Call another template
	//

	'apply-template': function(input, output, context) {
		var name = input.getAttribute('name');

		hi5.template.apply(name, output, context);
	}

};


//
// <os:message key="key" [parameter="value"]/>
//
// Output a localized message
//

hi5.template.hi5ml_tags['os:message'] = function(input, output, context) {
	if (!this._prefs) {
		this._prefs = new gadgets.Prefs();
	}

	var attrs = input.attributes;
	var message = this._prefs.getMsg(input.getAttribute('key'));
	var substitutions = {};

	if (!message) {
		message = input.firstChild.nodeValue;
	}

	for (var i = 0; i < attrs.length; i++) {
		substitutions[attrs[i].nodeName] = hi5.template.replace(attrs[i].nodeValue, context);
	}

	var value = hi5.template.replace(message, substitutions);
	output.appendChild(document.createTextNode(value));
},

//
// <os:name [person="person"] [uid="viewer|owner|id"] linked=[true|flase]/>
//
// Output a person's name
//

hi5.template.hi5ml_tags['os:name'] = function(input, output, context) {
	var uid = input.getAttribute('uid');
	var person = input.getAttribute('person');
	var linked = input.getAttribute('linked');
	var displayName, profileUrl;

	if (uid) {
		uid = hi5.template.replace(uid, context);

		var request = opensocial.newDataRequest();

		if (uid == 'viewer') {
			request.add(request.newFetchPersonRequest('VIEWER'), 'user');
        } else if (uid == 'owner') {
			request.add(request.newFetchPersonRequest('OWNER'), 'user');
		} else {
			request.add(request.newFetchPersonRequest(uid), 'user');
		}

		request.send(function(response) {
			var viewer = response.get('user').getData();

			outputName(viewer, linked, output);
		});
	} else if (person) {
		with (context) {
			person = eval(person);
		}

		outputName(person, linked, output);
	}

	function outputName(member, linked, output) {
			var displayName = member.getDisplayName();
			var profileUrl = member.getField(opensocial.Person.Field.PROFILE_URL);

			var nameNode = document.createTextNode(displayName);
			if (linked) {
				var linkNode = document.createElement('a');
				linkNode.href = profileUrl;
				linkNode.appendChild(nameNode);

				output.appendChild(linkNode);
			} else {
				output.appendChild(nameNode);
			}
	}
},

//
// <os:profile-pic [person="person"] [uid="viewer|owner|id"] [size="small|thumb"/>
//
// Output a member profile photo
//

hi5.template.hi5ml_tags['os:profile-pic'] = function(input, output, context) {
	var uid = input.getAttribute('uid');
	var person = input.getAttribute('person');
	var size = input.getAttribute('size');

	size = hi5.template.replace(size, context);

	var imgNode = document.createElement('img');

	if (uid) {
		uid = hi5.template.replace(uid, context);
		var request = opensocial.newDataRequest();

		if (uid == 'viewer') {
			request.add(request.newFetchPersonRequest('VIEWER'), 'user');
		} else if (uid == 'owner') {
			request.add(request.newFetchPersonRequest('OWNER'), 'user');
		} else {
			request.add(request.newFetchPersonRequest(uid), 'user');
		}

		request.send(function(response) {
			imgNode.src = response.get('user').getData().getField('thumbnailUrl');

			outputImage(size, output);
		});
	} else if (person) {
		with (context) {
			person = eval(person);
		}

		imgNode.src = person.getField('thumbnailUrl');

		outputImage(size, output);
	}

	function outputImage(size, output) {
		switch (size) {
			case 'small':
				imgNode.width = '100';
				imgNode.height = '100';
			break;
			case 'thumb':
			default:
				imgNode.width = '50';
				imgNode.height = '50';
			break;
		}

		output.appendChild(imgNode);
	}
}
