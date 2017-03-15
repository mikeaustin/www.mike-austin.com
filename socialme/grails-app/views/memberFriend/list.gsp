<html>
<head>
	<meta name="layout" content="socialme"/>
	<meta name="menu" content="friends"/>
	<g:javascript library="jquery" />
	<title>Friends</title>
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
			<h2 class="first">Friends</h2>
			<div style="margin-bottom: 5px;">Tags: &nbsp; <a href="#">Coworkers</a> &nbsp; <a href="#">Family</a> &nbsp; <a href="#">School</a></div>
			<ul>
				<g:each var="friend" in="${friends}" status="index">
					<li class="hover-item xhover cleared" style="margin-top: ${index == 0 ? '0' : '10px'}; border-top: 1px dotted #c0c0c0; padding-top: 5px;">
						<div class="after" style="margin-top: 8px;">
							<span>${friend.notes}</span>
						</div>
						<div class="before">
							<img src="/socialme/images/thumbnail_frame_50.png" style="position: absolute; margin-left: -4px; margin-top: -2px;"/>
							<img src="${friend.friend.thumbnailURL}" width="50" height="50" style="margin-right: 10px; margin-left: 2px; margin-top: 4px;"/>
						</div>
	
						<h3 class="item" xstyle="border-bottom: 1px dotted #c0c0c0;"><g:link controller="member" action="show" id="${friend.friend.id}">${friend.friend.name}</g:link></h3>

						<div class="hover-on">
							<div><a href=#">Nudge</a> &nbsp; <a href=#">Send Message</a> &nbsp; <a href="javascript:void($('#details-${index}').css('display', 'block'))">Edit Details</a></div>
						</div>
						<div class="hover-off">
							<div>&ldquo;${friend.friend.status}&rdquo;</div>
						</div>
						<div id="details-${index}" style="clear: left; xpadding-top: 10px; margin-left: 60px; display: none;">
							<table>
								<tr class="first"><td>Notes:</td><td>&nbsp;</td><td>Tags:</td></tr>
								<tr class="first"><td><g:textArea name="notes" rows="3" value="${friend.notes}" style="width: 200px;"/></td><td>&nbsp;</td><td><g:textField name="tags" style="width: 195px;"/></td></tr>
							</table>
						</div>
					</li>
				</g:each>
			</ul>
		</div>
		
		<div class="after" style="width: 260px;">
			<div class="module first">
				<h2 class="first">Tools</h2>
				<ul>
					<li class="first"><a href="#">Invite more Friends to SocialME</a></li>
					<li><a href="#">Search or Browse for Friends</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
