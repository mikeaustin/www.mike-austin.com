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
	
		gadgets.io.makeRequest('http://www.mike-austin.com/events/application.html?' + Math.random(), application.onLoadTemplates);
	},

	onLoadTemplates: function(response) {
		hi5.template.parse(response.data);
	
		hi5.template.apply('home', 'page-content', {viewer: application.viewer});
		eventsList.update();
	},

	viewMemberProfile: function(member_id) { 
	    var views = gadgets.views.getSupportedViews(); 

	    gadgets.views.requestNavigateTo(views['profile'], null, member_id);
	},

	sendInvites: function() {
		opensocial.requestShareApp('VIEWER_FRIENDS', "reason", function(response) {
			console.log(response);
		});
	}

};

gadgets.util.registerOnLoadHandler(application.initialize);


//
// Events list functions
//

var eventsList = {

	offset: 0,
	style: 'tiles',
	pagesize: 18,

	update: function() {
		var params = {};
		//params[gadgets.io.RequestParameters.CONTENT_TYPE] = gadgets.io.ContentType.JSON;

		gadgets.io.makeRequest('http://api.mike-austin.com/events/getEvents.php?' + Math.random(), function(response) {
			var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
			var events = eval(response.data);

			document.getElementById('events').innerHTML = '';
	
			hi5.template.apply('events', 'events', {months: months, events: events});
		}, params);
	},

	paginateFriends: function(direction) {
		switch (direction) {
			case 'next':
				this.offset += this.pagesize;
			break;
		}
	
		this.updateFriends();
	},

	selectEvent: function(element, event_id) {
		var nodes = element.parentNode.childNodes;
		
		for (var i = 0; i < nodes.length; i++) {
			nodes[i].className = 'event';
		}
		
		element.className = 'event selected';
	},

	createEvent: function() {
		document.getElementById('new-event').style.display = 'block';
	}

};
