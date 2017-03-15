<html>
<head>
	<meta name="layout" content="socialme"/>
	<meta name="menu" content="events"/>
	<title>Events</title>
</head>
<body>
	<div id="body" class="cleared">
		<div class="before" style="width: 480px;">
			<div id="content">
				<h2 class="first">My Events</h2>
				<g:render template="summary" model="[events: events]"/>

				<h2>Friends' Events</h2>
				<g:render template="summary" model="[events: friendEvents]"/>
			</div>
		</div>

		<div class="after" style="width: 260px;">
			<div class="module first">
				<h2 class="first">Tools</h2>
				<ul>
					<li class="first"><a href="#">Summary of All Events</a></li>
					<li><a href="#">My Friends' Events</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
