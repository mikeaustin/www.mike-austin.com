<head>
	<meta name="layout" content="socialme"/>
	<meta name="menu" content="home"/>
	<title>Events</title>
</head>
<body>
	<div id="body" class="cleared">
		<div class="before" style="width: 480px;">
			<div id="profile-small" class="cleared">
				<div class="before" style="margin-right: 5px;">
					<img src="/socialme/images/thumbnail_frame_50.png" style="position: absolute; margin-left: -4px; margin-top: -2px; cursor: pointer;" onclick="showLargeProfile()"/>
					<img src="${member.thumbnailURL}" width="50" height="50" style="margin-right: 10px; margin-left: 2px; margin-top: 4px;"/>
				</div>

				<div class="before" style="xwidth: 300px;">
					<h1 class="small first" style="xpadding-top: 3px;">${fieldValue(bean: member, field: 'name')}</h1>
					<div style="margin-top: 5px;">
						<a href="#">Edit Profile</a> &nbsp; <a href="#">Change My Room</a>
					</div>
				</div>
			</div>

			<div id="content" style="margin-top: 10px;">
				<h2 class="first">Room</h2>

				<div style="position: relative; height: 300px; background: url(/socialme/images/room_frame_backgr.gif) no-repeat; border: 1px solid #e0e0e0;">
					<g:each var="item" in="${items}">
						<img class="item" src="${item.objectURL}" style="position: absolute; left: ${item.posX}px; top: ${item.posY}px;"/>
					</g:each>
				</div>
			</div>
		</div>

		<div class="after" style="width: 260px;">
			<div class="module first">
				<h2 class="first">Items</h2>
				<ul>
					<li class="first">
						<img src="http://socialme.us:8080/socialme/images/assets/alien_128.png" height="64"/>
						<img src="http://socialme.us:8080/socialme/images/assets/cat_64.png" height="64"/>
						<img src="http://socialme.us:8080/socialme/images/assets/black_guitar-128x128.png" height="64"/>
					</li>
					<li><a href="#">Get More Items for your Room</a></li>
				</ul>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var mouseDown = false;
		
		$(".item").mousedown(function(event) {
			event.preventDefault()
			mouseDown = true
			$(this).attr("firstX", event.clientX - event.target.offsetLeft);
			$(this).attr("firstY", event.clientY - event.target.offsetTop);
		});

		$(".item").mouseup(function(event) {
			event.preventDefault()
			mouseDown = false
		});

		$(".item").mousemove(function(event) {
			event.preventDefault()
			if (mouseDown) {
				$(this).css("left", event.clientX - $(this).attr("firstX") + "px");
				$(this).css("top", event.clientY - $(this).attr("firstY") + "px");
			}
		});
	</script>
</body>
