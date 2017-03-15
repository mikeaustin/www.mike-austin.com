<ul>
	<g:each var="event" in="${events}" status="index">
		<li class="${index == 0 ? 'first' : ''}">
			<%--<div class="after center" style="border: 1px solid #404040; background: url(/socialme/images/dark_button_backgr.gif) repeat-x;">
				<div class="white" style="padding: 0 5px;">${formatDate(format: "MMM d", date: event.startDate)}</div>
				<div class="small white" style="background: #404040;">${formatDate(format: "yyyy", date: event.startDate)}</div>
			</div>--%>

			<div class="after center" style="border: 1px solid #404040; background: url(/socialme/images/main_header_backgr.gif) bottom left repeat-x;">
				<div class="white small" style="background: #404040; padding: 0 5px;">${formatDate(format: "MMM", date: event.startDate)}</div>
				<div class="white" style="font-weight: bold; xbackground: #ffffff;">${formatDate(format: "d", date: event.startDate)}</div>
			</div>

			<div class="after center small" style="margin-right: 5px; margin-top: 2px;">
				<span class="small light">starts at</span><br/>${formatDate(format: "h:mm a", date: event.startDate)}
			</div>
			
			<h3 style="margin: 0;"><g:link controller="event" action="show" id="${event.id}">${event.name}</g:link></h3>
			<div>${event.venue} &middot; ${event.location}</div>
		</li>
	</g:each>
</ul>
