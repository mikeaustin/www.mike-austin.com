<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><g:layoutTitle default="Grails" /></title>
	<link rel="stylesheet" href="${createLinkTo(dir: 'css', file: 'socialme.css')}" />
	<link rel="shortcut icon" href="${createLinkTo(dir: 'images', file: 'favicon.ico')}" type="image/x-icon" />
	<g:layoutHead />
	<g:javascript library="application" />
	<g:javascript library="jquery" />
	<style type="text/css">
		#menu-${pageProperty(name: 'meta.menu')} { background: #404040; }
	</style>
</head>
<body>
	<div id="page" class="${session.member ? 'loggedin' : ''}">
		<div id="black-overlay" style="position: absolute; top: 0; right: 0; bottom: 0; left: 0; background: black; opacity: 0.5; filter: alpha(opacity=50); visibility: hidden; z-index: 1;"></div>
		<div id="login-dialog" style="position: absolute; left: 50%; top: 50%; width: 300px; xheigt: 300px; margin-left: -150px; xmargin-top: -150px; border: 1px solid #404040; visibility: hidden; z-index: 1;">
			<div style="position: absolute; top: -7px; right: -7px; bottom: -7px; left: -7px; background: #e0e0e0; opacity: 0.5; filter: alpha(opacity=50);"></div>
			<div style="background: #f0f0f0; position: relative;">
				<h3 style="margin: 0 5px; padding: 7px 5px; padding-bottom: 6px; border-bottom: 1px dotted #c0c0c0;">Login</h3>
				<g:form name="login" url="[controller: 'account', action: 'login']" onSuccess="hideLoginDialog()" style="padding: 10px;">
					<table cellspacing="0" cellpadding="0" width="100%">
						<tr class="first"><th>E-mail:</th><td width="99%"><g:textField id="email-field" name="email" xvalue="tester@socialme.us" style="width: 93%;"/></td></tr>
						<tr><th>Password:</th><td><g:passwordField name="password" style="width: 93%;"/></td></tr>
					</table>
					<div class="item center">
						<g:submitButton name="login" value="Login" style="padding: 5px 5px; overflow: visible; background: url(/socialme/images/glossy_button_backgr.gif) repeat-x; border: 1px solid #d0d0d0;"/>
					</div>
				</g:form>
			</div>
		</div>

		<div id="header">
			<div style="float: right; margin: 9px 11px;">
				<a href="javascript:(function(){var $=document.getElementById;var message=prompt('Optional comment:','');if(message!=null){window.location='http://socialme.us:8080/socialme/share?url='+encodeURIComponent(document.location)+'&title='+encodeURIComponent(document.title)+(message!=''?'&message='+encodeURIComponent(message):'')};void(0);}());
"
				   title="Share content from other sites" style="padding: 2px 5px 3px 5px; background: #606060; border: 1px solid #404040;" 
				   onclick="alert('Bookmark this link to share content from other sites'); return false">Share on SocialME</a> &nbsp;&nbsp;&nbsp;
				<span id="account-links">
					<g:if test="${session.member}">
						${fieldValue(bean: session.member, field: 'name')} &nbsp;&middot;&nbsp;
						<g:link controller="account" action="logout">Logout</g:link>
					</g:if>
					<g:else>
						<a href="javascript:showLoginDialog()">Login</a>
					</g:else>
				</span>
			</div>
			<ul id="navigation" class="xcleared">
				<li id="menu-home" class="before"><g:link controller="member" action="show" id="${session?.member?.id}">SocialME</g:link></li>
				<li id="menu-friends" class="before"><g:link class="list" controller="memberFriend" action="list" id="">Friends</g:link></li>
				<li id="menu-photos" class="before"><g:link controller="memberPhoto" action="list">Photos</g:link></li>
				<li id="menu-places" class="before"><g:link controller="place" action="list">Places</g:link></li>
				<li id="menu-events" class="hover before" style="position: relative;">
					<div class="hidden" style="position: absolute;">
						<g:link controller="event" action="list" class="before" style="background: #404040;">Events</g:link>
						<div class="submenu" style="clear: both; position: absolute; top: 36px; background: #404040 url(/socialme/images/dark_button_backgr.gif) repeat-x; zoom: 1; border: 1px solid #404040; padding: 6px 0;">
							<g:remoteLink url="[controller: 'idea', action: 'create']" update="[success: 'content']" style="display: block; padding: 3px 10px; white-space: nowrap;">I have an idea about an event</g:remoteLink>
							<g:remoteLink url="[controller: 'event', action: 'create']" update="[success: 'content']" style="display: block; padding: 3px 10px; white-space: nowrap;">I know what I want to do</g:remoteLink>
							<g:remoteLink url="[controller: 'content', action: 'share']" update="[success: 'content']" style="display: block; padding: 3px 10px; white-space: nowrap;">Copy an event from another site</g:remoteLink>
						</div>
					</div>
					<g:link controller="event" action="list">Events</g:link>
				</li>
				<li id="menu-lists" class="before"><g:link controller="ideaList" action="list">Lists</g:link></li>
				<li>&nbsp;</li>
			</ul>
		</div>

		<div id="spinner" class="spinner" style="display: none;">
			<img src="${createLinkTo(dir: 'images', file: 'spinner.gif')}" alt="Spinner" />
		</div>	
		<g:layoutBody />		
	</div>

	<div id="footer">
		Copyright 2009 SocialME.us
	</div>

	<script type="text/javascript">
		function showLoginDialog() {
			var overlay = $("#black-overlay");
			var dialog = $("#login-dialog");

			overlay.css("visibility", "visible");
			dialog.css("visibility", "visible");
			dialog.css("marginTop", -dialog.attr("offsetHeight") / 2 + "px");
			
			$("#email-field").focus();
		}

		function hideLoginDialog() {
			jQuery("body").addClass("loggedin");

			var overlay = $("#black-overlay");
			var dialog = $("#login-dialog");

			overlay.css("visibility", "hidden")
			dialog.css("visibility", "hidden");
		}
	</script>
</body>	
</html>
