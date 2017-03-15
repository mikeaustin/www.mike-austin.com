<%-- Status Template --%>

<g:setProvider library="jquery"/>

<div id="status">
	&ldquo;${fieldValue(bean: member, field: 'status')}&rdquo;
	<g:if test="${member?.id == session.member?.id}">
		<g:formRemote id="status-form" name="status-form" url="[controller: 'member', action: 'setStatus']" update="status" onFailure="showLoginDialog()" style="border: 1px solid #e0e0e0;">
			<g:hiddenField name="type"/>
			<div class="hover before" style="position: relative;">
				<div class="hidden" style="position: absolute;">
					<div class="dark-button before" style="background: #404040; border-bottom: none;"><img class="before" src="/socialme/images/icons/help.png" style="padding: 2px 0;"/></div>
					<div class="submenu" style="clear: both; background: #404040 url(/socialme/images/dark_button_backgr.gif) repeat-x; border: 1px solid #404040; padding: 3px 0;">
						<a href="javascript:setStatus('is_happy')" style="display: block; padding: 3px 5px 3px 30px; white-space: nowrap; background: url(/socialme/images/icons/emoticon_grin.png) 5px 4px no-repeat;">is happy ^_^</a>
						<a href="javascript:setStatus('is_sad')" style="display: block; padding: 3px 5px 3px 30px; white-space: nowrap; background: url(/socialme/images/icons/emoticon_unhappy.png) 5px 4px no-repeat;">is sad :(</a>
						<a href="javascript:setStatus('wants_to')" style="display: block; padding: 3px 5px 3px 30px; white-space: nowrap; background: url(/socialme/images/icons/lightbulb.png) 5px 4px no-repeat;">wants to...</a>
						<a href="javascript:setStatus('interest')" style="display: block; padding: 3px 5px 3px 30px; white-space: nowrap; background: url(/socialme/images/icons/group.png) 5px 4px no-repeat;">Interested in...</a>
					</div>
				</div>
				<div class="dark-button" style="background: #ffffff; border: 1px solid #ffffff; border-bottom: none; border-right: 1px solid #e0e0e0; margin-right: 5px;"><img src="/socialme/images/icons/help.png" style="padding: 2px 0;"/></div>
			</div>
			<div>
				<g:textField id="status" name="status" value="Change your status..." size="30" style="background: none; border: none;"/>
				<g:submitButton name="submit" value="Set" style="padding: 0;"/>
			</div>
		</g:formRemote>
	</g:if>
</div>
