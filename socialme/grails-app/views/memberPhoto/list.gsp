<html>
<head>
	<meta name="layout" content="socialme"/>
	<meta name="menu" content="photos"/>
	<g:javascript library="jquery" />
	<title>Photos</title>
	<style>
		x.hover-item:hover		{ background: #f0f0f0; }
		
		.xhover .hover-on			{ display: none; }
		.xhover .hover-off			{ display: block; }
		.xhover:hover .hover-on		{ display: block; }
		.xhover:hover .hover-off	{ display: none; }

		.xhover:hover span.hover-on	{ display: inline; }
	</style>
</head>
<body>
	<div id="body" class="cleared">
		<div class="before" style="width: 480px;">
			<h2 class="first">Friends' Photos</h2>
			<div style="margin-bottom: 5px;">Tags: &nbsp; <a href="#">Coworkers</a> &nbsp; <a href="#">Family</a> &nbsp; <a href="#">School</a></div>
			<ul class="cleared">
				<g:each var="photo" in="${photos}" status="index">
					<li class="before" style="${index == 0 ?: 'margin-left: 5px;'} background: white; padding: 3px; border: 1px solid #c0c0c0; xheight: 54px; overflow: hidden; line-height: 0;">
						<g:remoteLink controller="photo" action="showajax" id="${photo.id}" update="content" onSuccess="showSmallProfile()" style="line-height: 0;">
							<img src="${photo.thumbURL}" width="70" xheight="40" border="0"/></g:remoteLink>
					</li>
				</g:each>
			</ul>
			<div class="content">
			</div>
		</div>
		
		<div class="after" style="width: 260px;">
			<div class="module first">
				<a href="#">Upload Photos</a>
			</div>
		</div>
	</div>
</body>
