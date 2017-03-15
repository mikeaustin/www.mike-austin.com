<html>
<head>
	<meta name="layout" content="socialme"/>
	<meta name="menu" content="events"/>
	<g:javascript library="jquery" />
	<title>Event</title>
</head>
<body>
	<div id="body" class="cleared">
		<div class="before" style="width: 480px;">
			<g:if test="${flash.message}">
				<div class="message">${flash.message}</div>
			</g:if>
			
			<g:render template="summary" model="[events: [event]]"/>
			
			<div class="item">
				<g:if test="${!event.confirmed}">
					<span class="after warn">This event has NOT yet been confirmed</span>
				</g:if>
				<a href="#">Driving Directions</a>
			</div>
			
			<div id="map" style="width: 480px; height: 300px; margin-top: 5px;"></div>
		</div>

		<div class="after" style="width: 260px;">
			<div class="module first">
				<h2 class="first">Attendies</h2>
				<ul>
					<g:each var="attendie" in="${attendies}">
						<li>
							<div class="after">[${attendie.status}]</div>
							<div><g:link controller="member" action="show" id="${attendie.member.id}">${attendie.member.name}</g:link></div>
						</li>
					</g:each>
				</ul>
			</div>

			<div class="module">
				<h2 class="first">Notes</h2>
				<ul>
					<div>${event.notes}</div>
				</ul>
			</div>
		</div>
	</div>
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA4eCZCoi_hsIjmHiYHRYYyxRdLbEPcWF6qurKq5VCfxgOG7RqXBRzdpdphntwovF-Q654z86WGzYGhg" type="text/javascript"></script>
	<script type="text/javascript">
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
	</script>
</body>
</html>
