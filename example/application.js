//
// Sample Localized Application using hi5.template
//

var application = {

	viewer: null,
	owner: null,

	initialize: function() {
		var request = opensocial.newDataRequest();
	
		request.add(request.newFetchPersonRequest('VIEWER'), 'viewer');
		request.add(request.newFetchPersonRequest('OWNER'), 'owner');
	
		request.send(application.onLoadFriends);
	},

	onLoadFriends: function(response) {
		application.viewer = response.get('viewer').getData();
		application.owner = response.get('viewer').getData();
	
		gadgets.io.makeRequest('http://www.mike-austin.com/example/application.html?' + Math.random(), application.onLoadTemplates);
	},

	onLoadTemplates: function(response) {
		hi5.template.parse(response.data);
	
		hi5.template.apply('home', 'page-content', {viewer: application.viewer});
		friendsList.updateFriends();
	},

	viewMemberProfile: function(member_id) { 
	    var views = gadgets.views.getSupportedViews(); 

	    gadgets.views.requestNavigateTo(views['profile'], null, member_id);
	}

};

gadgets.util.registerOnLoadHandler(application.initialize);


//
// Friends list functions
//

var friendsList = {

	offset: 0,
	style: 'tiles',
	pagesize: 18,

	updateFriends: function() {
		var request = opensocial.newDataRequest();
	
		var params = {};
		params[opensocial.DataRequest.PeopleRequestFields.FIRST] = this.offset;
		params[opensocial.DataRequest.PeopleRequestFields.MAX] = this.pagesize;
		request.add(request.newFetchPeopleRequest('OWNER_FRIENDS', params), 'friends');
	
		request.send(function(response) {
			var friends = response.get('friends').getData();
	
			document.getElementById('friends').innerHTML = '';
	
			switch (friendsList.style) {
				case 'tiles':
					hi5.template.apply('friends-tiles', 'friends', {friends: friends});
				break;
				case 'list':
					hi5.template.apply('friends-list', 'friends', {friends: friends});
				break;
			}
		});
	},

	paginateFriends: function(direction) {
		switch (direction) {
			case 'next':
				this.offset += this.pagesize;
			break;
		}
	
		this.updateFriends();
	},

	setListStyle: function(style) {
		switch (style) {
			case 'tiles':
				this.style = 'tiles';
				this.pagesize = 18;
			break;
			case 'list':
				this.style = 'list';
				this.pagesize = 60;
			break;
		}
	
		this.offset = 0;
		this.updateFriends();
	}

};

var _parse = hi5.template.parse;
hi5.template.parse = function(template) {
	template = template.replace(/&/g, '&amp;');
	return _parse.call(hi5.template, template);
}

hi5.template.messages = {};

hi5.template.hi5ml_tags['os:message'] = function(input, output, context) {
	if (!this._prefs) {
		this._prefs = new gadgets.Prefs();
	}

	var attrs = input.attributes;
	var key = input.getAttribute('key');
	var message = this._prefs.getMsg(key);

	var substitutions = {};

	if (!message) {
		message = input.firstChild.nodeValue;
	}

	for (var i = 0; i < attrs.length; i++) {
		substitutions[attrs[i].nodeName] = hi5.template.replace(attrs[i].nodeValue, context);
	}

	var value = hi5.template.replace(message, substitutions);
	output.appendChild(document.createTextNode(value));

	hi5.template.messages[key] = message.replace('&', '&amp;', 'g');
}
