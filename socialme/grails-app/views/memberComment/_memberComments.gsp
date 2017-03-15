<g:if test="${comments}">
    <ul class="cleared" style="margin: 0; padding: 0;">
        <g:each var="comment" in="${comments}" status="index">
            <g:if test="${index == 0}">
                <g:set var="style" value="margin-top: 0;"/>
            </g:if>
            <li style="margin-top: 10px; ${style} list-style: none; overflow: hidden; zoom: 1;">
                <div style="float: left;">
                    <img src="/socialme/images/thumbnail_frame_50.png" style="position: absolute; margin-left: -4px; margin-top: -2px;"/>
                    <img src="${comment.sender.thumbnailURL}" width="50" height="50" style="margin-right: 10px; margin-left: 2px; margin-top: 4px;"/>
                </div>
                <div style="border-bottom: 1px dotted #c0c0c0;">
                    On ${formatDate(format: "MMM d", date: comment.commentDate)},
                    <g:link controller="member" action="show" id="${comment.sender.id}">${fieldValue(bean: comment, field: 'sender.name')}</g:link> said:
                </div>
                <div style="xmargin-top: 5px;">${fieldValue(bean: comment, field: 'message')}</div>
            </li>
               <g:set var="style" value=""/>
        </g:each>
    </ul>
</g:if>
<g:else>
    ${member.name} has no comments
</g:else>

<div style="margin-top: 10px;">
    <g:formRemote name="comment" url="[controller: 'memberComment', action: 'ajaxsave']" update="[success: 'comments']" onFailure="showLoginDialog()">
        <g:hiddenField name="member.id" value="${member.id}"/>
        <%--<div>Give ${member.name} a comment...</div>--%>
        <fieldset style="padding: 0 0; background: #fffacd; border: 1px solid #e0e0e0; ">
            <g:textArea name="message" style="border: none; background: #fffacd; width: 100%; height: 55px;" value="Type a comment here..." onclick="this.value = ''"/>
        </fieldset>
        <div align="center" class="item">
			<g:if test="${session.member}">
	            <g:submitButton name="addComment" value="Add Comment" style="padding: 5px 5px; font-weight: bold; overflow: visible; background: url(/socialme/images/glossy_button_backgr.gif) repeat-x; border: 1px solid #d0d0d0;"/>
			</g:if>
			<g:else>
				<span>Please <a href="javascript:showLoginDialog()">Login</a> or <a href="javascript:showRegisterDialog()">Join</a><br/>to leave a comment</span>
			</g:else>
        </div>
    </g:formRemote>
</div>
