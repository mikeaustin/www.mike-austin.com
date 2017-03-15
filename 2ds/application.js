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
	
		gadgets.io.makeRequest('http://www.mike-austin.com/2ds/application.html?' + Math.random(), application.onLoadTemplates);
	},

	onLoadTemplates: function(response) {
		hi5.template.parse(response.data);
	
		hi5.template.apply('home', 'page-content', {viewer: application.viewer});
		//friendsList.updateFriends();
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

	updateFriends: function(search_text) {
		var request = opensocial.newDataRequest();
	
		var params = {};
		//params[opensocial.DataRequest.PeopleRequestFields.FIRST] = this.offset;
		params[opensocial.DataRequest.PeopleRequestFields.MAX] = 50;
		request.add(request.newFetchPeopleRequest('OWNER_FRIENDS', params), 'friends');

		request.send(function(response) {
			var friends = response.get('friends').getData();

/*
			var request = opensocial.newDataRequest();
			var params = {};
			params[opensocial.DataRequest.PeopleRequestFields.PROFILE_DETAILS] = [opensocial.Person.Field.INTERESTS];
			request.add(request.newFetchPersonRequest(friends.asArray()[0].getId(), params), 'friend');
			request.send(function(response) {
				var friend = response.get('friend').getData();
				console.log(friend);
			});
*/
			document.getElementById('friends').innerHTML = '';

			friends.each(function(friend) {
				gadgets.io.makeRequest('http://www.hi5.com/friend/profile/displayProfile.do?userid=' + friend.getId(), function(response) {
					var interests = $(response.data).find("#interests").find(".box_profile_info_small_content").text();
					if (interests && interests.match(search_text, "ig")) {
						console.log(friend.getDisplayName());
						//interests = interests.replace(search_text, "<b>" + search_text + "</b>");
						hi5.template.apply('friend-tile', 'friends', {friend: friend, interests: interests});
					}
				});
			});

/*
			document.getElementById('friends').innerHTML = '';
	
			switch (friendsList.style) {
				case 'tiles':
					hi5.template.apply('friends-tiles', 'friends', {friends: friends});
				break;
				case 'list':
					hi5.template.apply('friends-list', 'friends', {friends: friends});
				break;
			}
*/
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
