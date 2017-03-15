<%-- Updates Template --%>

<ul id="updates" class="icon-list">
	<li class="header" style="background: url(images/member-20x20.gif) 0 3px no-repeat;">Today</li>
	<g:each var="update" in="${updates}" status="index">
		<li class="indent cleared" style="background-image: url(${update.iconURL});">
			<div class="after light">
				<%--${formatDate(format: "MMM d", date: update.createdDate)}--%>
				${formatDate(format: "h:mma", date: update.createdDate)}
			</div>
			<div>
				${update.getFormattedString()} &nbsp;&ndash;&nbsp;
				<g:if test="${update.type == UpdateType.STATUS}">
					<a href="javascript:showComment('${index}', 'smileys');" style="font-size: 10px; border-bottom: 1px dotted #c0c0c0;" class="small light">Comment</a> &nbsp;
					<a href="#" style="font-size: 10px; border-bottom: 1px dotted #c0c0c0;" class="small light">Add to faves</a>
				</g:if>
				<g:if test="${update.type == UpdateType.IDEA}">
					<a href="javascript:showComment('${index}', 'suggest');" style="font-size: 10px; border-bottom: 1px dotted #c0c0c0;" class="small light">I'm interested</a> &nbsp;
					<a href="#" style="font-size: 10px; border-bottom: 1px dotted #c0c0c0;" class="small light">Add to faves</a>
				</g:if>
			</div>
			<div>
				<g:if test="${update.getThumbnailURL()}">
					<img class="before item" src="${update.getThumbnailURL()}" width="70" style="margin-right: 5px;"/>
				</g:if>
				<g:if test="${update.title}">
					<div><a href="${update.url2}" target="_blank">${update.title}</a></div>
				</g:if>
				<g:if test="${update.getMessageSnippet()}">
					<div>&ldquo;${update.getMessageSnippet()}&rdquo;</div>
				</g:if>

				<div id="comment-${index}" class="item" style="display: none;">
					<g:form controller="memberUpdate" action="comment">
						<div id="comment-${index}-smileys" style="display: none;">
							<img src="/socialme/images/smileys/001_smile.gif"/>
							<img src="/socialme/images/smileys/ohmy.gif"/>
							<img src="/socialme/images/smileys/laugh.gif"/>
						</div>
						<div id="comment-${index}-suggest" style="display: none;">
							Suggest a place and date:<br/>
							<g:textField name="suggest-place" value="place..."/> <g:textField name="suggest-date" value="date"/>
						</div>
						<div>
							Comment:<br/>
							<g:textArea name="message" style="width: 300px; height: 36px;"/><br/>
							<g:submitButton name="submit" value="Comment"/>
						</div>
					</g:form>
				</div>
			</div>
		</li>
	</g:each>
	
	<%--<li class="header" style="background: url(images/member-20x20.gif) 0 3px no-repeat;">Andy V.</li>
	<li class="indent"><a href="#">Andy V.</a> sent you a message <a href="#">Hey dude, what up?</a></li>

	<li class="indent"><a href="#">Andy V.</a> replied to your group message <a href="#">Why I like it</a></li>
	<li class="header" style="background: url(images/member-20x20.gif) 0 3px no-repeat;">Joe S.</li>
	<li class="indent"><a href="#">Joe S.</a> posted a message to <a href="#">Get Down with It</a> asdfasdf asdfasdf asdfasdfas asdfasfasdf</li>

	<li class="indent"><a href="#">Joe S.</a> posted a message to <a href="#">Get Down with It</a></li>
	<li class="header" style="background: url(images/member-20x20.gif) 0 3px no-repeat;">Jill W.</li>
	<li class="indent"><a href="#">Jill W.</a> posted a message to <a href="#">Get Down with It</a></li>--%>
</ul>
