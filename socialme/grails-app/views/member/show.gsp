<html>
<head>
	<meta name="layout" content="socialme"/>
	<meta name="menu" content="home"/>
	<g:javascript library="jquery" />
	<title>Profile</title>
	<script type="text/javascript">
		function showSmallProfile() {
			var large = $("#profile-large");
			var small = $("#profile-small");

			large.hide();
			small.show();
		}

		function showLargeProfile() {
			var large = $("#profile-large");
			var small = $("#profile-small");
			
			large.show();
			small.hide();
		}
	</script>
</head>
<body>
	<div id="body" class="cleared">
		<div class="before" style="width: 480px;">
			<div id="profile-large" xclass="cleared">
				<div class="before" style="margin-right: 10px;">
					<img src="/socialme/images/thumbnail_frame_100.png" style="position: absolute; margin-left: -10px; margin-top: -8px;"/>
					<img src="${member.thumbnailURL}" width="100" height="100" style="margin-right: 10px; margin-left: 3px; margin-top: 4px;"/>
				</div>

				<div class="before" style="xwidth: 300px;">
					<h1 class="first small" style="xpadding-top: 3px;">${fieldValue(bean: member, field: 'name')}</h1>
					<g:render template="status" model="[member: member]"/>

					<g:if test="${member?.id != session.member?.id}">
						<div style="clear: left;">Location: ${fieldValue(bean: member, field: 'location')}</div>
					</g:if>

					<div style="margin-top: 5px;">
						<g:if test="${session.member?.id == member.id}">
							<g:remoteLink action="edit" id="${member.id}" update="content">Edit Profile</g:remoteLink> &nbsp;
						</g:if>
						<g:else>
							<g:if test="${session.member && !session.member.isFriend(member)}">
								<span id="add-friend"><g:remoteLink controller="member" action="favajax" id="${member.id}" update="add-friend">Add as Buddy</g:remoteLink></span> &nbsp;
							</g:if>
							<a href="#">Nudge</a> &nbsp;
						</g:else>
						<g:link controller="member" action="room" id="${member.id}">${member.name}'s Room</g:link>
					</div>
				</div>
			</div>

			<div id="profile-small" class="cleared" style="display: none;">
				<div class="before" style="margin-right: 5px;">
					<img src="/socialme/images/thumbnail_frame_50.png" style="position: absolute; margin-left: -4px; margin-top: -2px; cursor: pointer;" onclick="showLargeProfile()"/>
					<img src="${member.thumbnailURL}" width="50" height="50" style="margin-right: 10px; margin-left: 2px; margin-top: 4px;"/>
				</div>

				<div class="before" style="xwidth: 300px;">
					<h1 class="small first" style="xpadding-top: 3px;">${fieldValue(bean: member, field: 'name')}</h1>
					<div style="margin-top: 5px;">
						<a href="#">Add as Buddy</a> &nbsp; <a href="#">Poke</a>
					</div>
				</div>
			</div>

			<div style="clear: left; padding-top: 15px; border-bottom: 1px solid #e0e0e0; margin-bottom: 10px;">
				<ul>
					<li class="before" style="margin: 0 5px; padding: 3px 10px; background: white; border: 1px solid #e0e0e0; border-bottom: 1px solid #ffffff; font-weight: bold;">Updates</li>
					<li class="before" style="margin: 0; padding: 3px 5px;">Photos</li>
					<li class="before" style="margin: 0; padding: 3px 5px;">Comments</li>
					<li style="margin: 0; padding: 3px 5px; border-bottom: 1px solid white;">&nbsp;</li>
				</ul>
			</div>

			<div id="content">
				<h2 class="first">Updates</h2>
				<g:render template="updates" model="${[updates: updates]}"/>

				<h2>Feeds</h2>
				<ul class="icon-list">
					<g:each var="item" in="${feed}">
						<li class="header">
							<div class="after">${formatDate(format: "MMM d", date: Date.parse("yyyy-MM-dd'T'HH:mm:ss", item.published.toString()))}</div>
							${item.title}
						</li>
						<li class="first">
							<div>${item.content}</div>
						</li>
					</g:each>
				</ul>
			</div>
		</div>

		<div class="after" style="width: 260px;">
			<div class="module first">
				<div class="hover after" style="margin-top: 5px; position: relative;">
					<div class="hidden" style="position: absolute; right: 0;">
						<div class="dark-button after" style="background: #404040;">New</div>
						<div style="clear: both; background: #404040 url(/socialme/images/dark_button_backgr.gif) repeat-x; border: 1px solid #404040; padding: 3px 0;">
							<g:remoteLink url="[controller: 'idea', action: 'create']" update="[success: 'content']" style="display: block; color: #f0f0f0; padding: 0 5px; white-space: nowrap;">I have an idea about an event</g:remoteLink>
							<g:remoteLink url="[controller: 'event', action: 'create']" update="[success: 'content']" style="display: block; color: #f0f0f0; padding: 0 5px; white-space: nowrap;">I know what I want to do</g:remoteLink>
							<g:remoteLink url="[controller: 'content', action: 'share']" update="[success: 'content']" style="display: block; color: #f0f0f0; padding: 0 5px; white-space: nowrap;">Copy an event from another site</g:remoteLink>
						</div>
					</div>
					<div class="dark-button">New</div>
				</div>
				<h2 class="first">Events</h2>
				<g:if test="${events}">
					<ul>
						<g:each var="event" in="${events}">
							<li>
								<span class="after" style="xfont-weight: bold; text-align: right;">${formatDate(format: "MMM d", date: event.event.startDate)}<br/><span style="font-size: 10px; color: #808080;">2009</span></span>
								<g:remoteLink controller="event" action="showajax" id="${event.id}" update="content">${fieldValue(bean: event.event, field: 'name')}</g:remoteLink><br/>
								<div style="color: #808080; font-size: 10px;">${event.event.venue} &middot; ${event.event.location}</div>
							</li>
						</g:each>
					</ul>
				</g:if>
				<g:else>
					${member.name} has no events
				</g:else>
			</div>

			<div id="photos" class="module">				
				<div class="hover after" style="margin-top: 5px;">
					<div class="hidden" style="position: absolute;">
						<div class="dark-button before" style="background: #404040;">New</div>
						<div style="clear: left; background: #404040 url(/socialme/images/dark_button_backgr.gif) repeat-x; border: 1px solid #404040; padding: 3px 5px;">
							<a href="#" style="display: block; color: #f0f0f0; padding: 0 5px;">Upload from my computer</a>
							<a href="#" style="display: block; color: #f0f0f0; padding: 0 5px;">Upload from a web image URL</a>
						</div>
					</div>
					<div class="dark-button">New</div>
				</div>
				<h2 class="first">Photos</h2>
				<g:if test="${member.photos}">
					<ul class="cleared">
						<g:each var="photo" in="${member.photos}" status="index">
							<li class="before" style="${index == 0 ?: 'margin-left: 5px;'} background: white; padding: 2px; border: 1px solid #c0c0c0; xheight: 54px; overflow: hidden; line-height: 0;">
								<g:remoteLink controller="memberPhoto" action="showajax" id="${photo.id}" update="content" onSuccess="showSmallProfile()" style="line-height: 0;">
									<img src="${photo.thumbURL}" width="70" xheight="40" border="0"/></g:remoteLink>
							</li>
						</g:each>
					</ul>
				</g:if>
				<g:else>
					${member.name} has no photos
				</g:else>
			</div>

			<div class="module" style="background: url(/socialme/images/member_room_backgr.jpg) no-repeat; height: 115px;">				
				<h2 class="first">Room</h2>
			</div>

			<div class="module">				
				<h2 class="first">Comments</h2>
				<div id="comments">
					<g:render template="/memberComment/memberComments" model="[comments: member?.comments]"/>
				</div>
			</div>
		</div>
	</div>
	
	<xscript src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA4eCZCoi_hsIjmHiYHRYYyxRdLbEPcWF6qurKq5VCfxgOG7RqXBRzdpdphntwovF-Q654z86WGzYGhg" type="text/javascript"></xscript>
	<script type="text/javascript">
		function setStatus(type, text) {
			var form = $("#status-form")[0]

			switch (type) {
				case "is_happy": $(form.status).val("is happy ^_^"); $(form.type).val("status"); break;
				case "is_sad": $(form.status).val('is sad >_<'); $(form.type).val("status"); break;
				case "wants_to": $(form.status).val('wants to '); $(form.type).val("wants_to"); break;
				case "interest": $(form.status).val('is interested in '); $(form.type).val("interest"); break;
			}
			
			$("#status").focus();
		}
		
		function showComment(commentId, style) {
			$("#comment-" + commentId).css('display', 'block');
			$("#comment-" + commentId + "-" + style).css("display", "block");
		}
	</script>
	<%--<script type="text/javascript">
		var map, geocoder;
	
		setTimeout(function() {
			if (GBrowserIsCompatible()) {
				map = new GMap2(document.getElementById("map"));
				map.setCenter(new GLatLng(37.4419, -122.1419), 13);
	
				geocoder = new GClientGeocoder();
			}
	
			if (geocoder) {
				geocoder.getLatLng("${event.address}, ${event.location}", function(point) {
					map.setCenter(point, 15);
					var marker = new GMarker(point);
					map.addOverlay(marker);
					marker.openInfoWindowHtml("<b>${event.venue}</b><br/>${event.address}<br/>${event.location}");
				});
			}
	
			map = new google.maps.Map2($("map"));
		}, 0);
	</script>--%>
</body>
</html>
