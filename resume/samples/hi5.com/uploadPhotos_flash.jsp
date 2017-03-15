<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="form" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<style>
	#flash-uploader {
		text-align: left; width: 400px; border: 1px solid #cccccc;
	}
	#flash-uploader #upload-text {
		margin-top: 90px; font-size: 12px; line-height: 1.4em; text-align: center;
	}
	#flash-uploader a {
		font-weight: normal;
	}
	#flash-uploader button {
		width: 206px; height: 42px; cursor: pointer; line-height: 42px; border: none;
		font-family: Arial, Helvetica, sans-serif; font-weight: bold; font-size: 16px; color: #222222; background: url(http://images.hi5.com/images/buttons/orange-button.jpg);
	}
	#flash-uploader #upload-div {
		width: 206px; height: 52px; margin: 0px auto 0 auto; visibility: hidden; position: relative;
	}
	#flash-uploader #upload-progress {
		position: absolute; height: 42px; background: white; opacity: 0.6; filter: alpha(opacity=60); cursor: pointer;
	}
	#flash-uploader #files-list {
		height: 200px; overflow: auto;
	}

	#flash-uploader #list-header {
		padding: 0px 8px; border-bottom: 1px solid #f3f3f3;
		background: url(http://images.hi5.com/images/header/main_nav_bg.jpg);
	}
	#flash-uploader #header-file {
		width: 270px;
	}
	#flash-uploader #header-size {
		width: 75px; text-align: right;
	}
	#flash-uploader .header-column {
		float: left; padding: 5px 0px; font-weight: bold;
	}
	#flash-uploader .item-row {
		border-bottom: 1px solid #f3f3f3; cursor: default;
		border-left: 8px solid white; border-right: 8px solid white;
	}
	#flash-uploader .item-column {
		float: left; padding: 5px 0px; padding: 0;
		height: 24px; line-height: 24px; overflow: hidden;
	}
	#flash-uploader .list-name {
		float: left; width: 250px; padding-left: 20px;
		background: url(http://images.hi5.com/images/icons/_/update_photos.gif) no-repeat 0px 5px;
	}
	#flash-uploader .item-size {
		width: 75px; text-align: right;
	}
	#flash-uploader .item-close {
		width: 12px; xpadding: 5px 0; float: right; cursor: pointer;
		background: url(http://images.hi5.com/images/icons/_/close_button.gif) no-repeat 0px 6px;
	}

	#flash-uploader .item-row.selected {
		background:#f3f3f3;
		border-left-color: #f3f3f3;
		border-right-color: #f3f3f3;
	}
	#flash-uploader .item-row.previous {
		border-left: none; border-right: none;
		padding-left: 8px; padding-right: 8px;
		xborder-left-color: #f3f3f3;
		xborder-right-color: #f3f3f3;
	}
</style>

<script>
	var uploadTool;
	var currentState;

	function MultiPowUpload_onMovieLoad() {
		if ($("EmbedFlashFilesUpload")) {
			uploadTool = $("EmbedFlashFilesUpload");
		} else {
			uploadTool = $("FlashFilesUpload");
		}

		setState(InitializeState);
	}

	function setState(state) {
		currentState = state;
		currentState.init();
	}

	function getState() {
		return currentState;
	}

	var InitializeState = {
		name: 'InitializeState',

		init: function() {
		},

		mainAction: function() {
			browseFiles();
		}
	};
</script>

<% String photoUploadServer = (String) getServletConfig().getServletContext().getAttribute("photoUploadServer"); %>
<div style="width: 400px; text-align: center;">
	<fmt:message key='message.photos.uploadPhotos.tryFlashyUploader'/>
	<object id="FlashFilesUpload" codeBase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
	 width="1" height="1" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" viewastext>
		<!-- Replace symbols " with the &quot; at all parameters values and
		symbols "&" with the "%26" at URL values or &amp; at other values!
		The same parameters values should be set for EMBED object below. -->
		<param name="FlashVars" value="uploadUrl=<c:out value='${photoUploadServer}'/>/friend/photos/uploadPhotos.do&useExternalInterface=Yes">
		<param name="BGColor" value="#F8F6E6">
		<param name="Movie" value="ElementITMultiPowUpload1.7.swf">
		<param name="Src" VALUE="ElementITMultiPowUpload1.7.swf">
		<param name="WMode" VALUE="Window">
		<param name="Play" VALUE="-1">
		<param name="Loop" VALUE="-1">

		<param name="Quality" VALUE="High">
		<param name="SAlign" VALUE="">
		<param name="Menu" VALUE="-1">
		<param name="Base" VALUE="">
		<param name="AllowScriptAccess" VALUE="always">
		<param name="Scale" VALUE="ShowAll">
		<param name="DeviceFont" VALUE="0">
		<param name="EmbedMovie" VALUE="0">
		<param name="SWRemote" VALUE="">

		<param name="MovieData" VALUE="">
		<param name="SeamlessTabbing" VALUE="1">
		<param name="Profile" VALUE="0">
		<param name="ProfileAddress" VALUE="">
		<param name="ProfilePort" VALUE="0">

		<!-- Embed for Netscape,Mozilla/FireFox browsers support. Flashvars parameters are the same.-->
		<!-- Replace symbols " with the &quot; at all parameters values and
		symbols "&" with the "%26" at URL values or &amp; at other values! -->
		<embed bgcolor="#F8F6E6" id="EmbedFlashFilesUpload"
		 src="ElementITMultiPowUpload1.7.swf" quality="high"
		 pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"
		 type="application/x-shockwave-flash" width="1" height="1" allowScriptAccess="always"
		 flashvars="uploadUrl=<c:out value='${photoUploadServer}'/>/friend/photos/uploadPhotos.do&useExternalInterface=Yes">
		</embed>
	</object>
</div>
<br/>

<script src="/friend/js/scriptaculous-1.8.1/prototype.js" type="text/javascript"></script>

<div style="margin-bottom: 10px;">
				<form method="post" name="upload">
					<table align="center" id="select-album">
						<tr>
							<td>
								<fmt:message key='message.photoshare.uploadphotos.uploadto'/>:
							</td>
							<td>
								<input type="hidden" name="type" value="0"/>
								<select name="albumId" style="width: 220px;">
									<logic:iterate id="oneAlbum" name="albums">
									  <c:if test="${oneAlbum.id == albumId}" >
										<option value="<c:out value='${oneAlbum.id}' />" selected><c:out value='${oneAlbum.name}' escapeXml='false' /></option>
									  </c:if>
									  <c:if test="${oneAlbum.id != albumId}" >
										<option value="<c:out value='${oneAlbum.id}' />" ><c:out value='${oneAlbum.name}' escapeXml='false' /></option>
									  </c:if>
									</logic:iterate>
								</select>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td align="right"><a href="javascript:createAlbum();"><fmt:message key='message.mngphotos.create'/> &raquo;</a></td>
						</tr>
					</table>

					<table align="center" id="create-album" style="display: none;">
						<tr>
							<td>
								<fmt:message key='message.photos.uploadphotos.albumname'/>:
							</td>
							<td>
								<input type="text" name="albumName" value="" size="30" maxlength="50">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td align="right"><a href="javascript:selectAlbum();">&laquo; <fmt:message key='message.photos.viewallalbs'/></a></td>
						</tr>
					</table>
				</form>
</div>

<div id="flash-uploader">
	<div id="list-header">
		<div class="header-column" id="header-file"><fmt:message key='message.photos.uploadPhotos.columnHeaderFile'/></div>
		<div class="header-column" id="header-size"><fmt:message key='message.photos.uploadPhotos.columnHeaderSize'/></div>
		<div class="p_clear"></div>
	</div>
	<div id="files-list">
		<div id="files">
			<div id="upload-text">
				<span style="font-weight: bold;"><fmt:message key='message.photos.uploadPhotos.pleaseSelectPhotos'/></span><br/>
				<fmt:message key='message.photos.uploadPhotos.holdDownShiftTip'/><br/><br/>
				<button onclick="browseFiles();"><fmt:message key='message.photos.uploadPhotos.buttonAddPhotos'/></button>
			</div>
		</div>
		<div id="add-more" style="padding: 5px 8px; display: none;">
			<a href="#" onclick="browseFiles();"><fmt:message key='message.photos.uploadPhotos.addMorePhotos'/></a>
		</div>
	</div>
	<div id="add-more2" style="padding: 5px 8px; margin-bottom: 5px; visibility: hidden;">
		<a href="#" onclick="browseFiles();"><fmt:message key='message.photos.uploadPhotos.addMorePhotos'/></a>
	</div>
	<div id="upload-div">
		<div id="upload-progress" onclick="cancelUpload();"></div>
		<button id="upload-button" onclick="getState().mainAction();"><fmt:message key='message.photos.uploadPhotos.buttonUploadPhotos'/></button>
	</div>
</div>

<br/>
<div id="log" align="left" style="height: 500px; display: none;"></div>
  <p align="right">
      <c:url var='simpleUploaderLink' value='/photos/displayUploadPhotos.do?albumId=${album.id}&uploadtool=simple'/>
      <a href="<c:out value='${simpleUploaderLink}'/>"><fmt:message key='message.photos.imageUploader.simpleUploader'/></a>&nbsp;&nbsp;&nbsp;
  </p>
<script defer="defer">
	var indentLevel = 0;
	var indexOffset = 0;
	var continueAlbum = false;
  var fileUploadCount = 0;

	function log(string) {
		for (i = 0; i < indentLevel; i++)
			$('log').innerHTML += '&nbsp;&nbsp;&nbsp;';
		$('log').innerHTML += string + '<br/>';
	}

	window.onbeforeunload = function() {
		if (uploadTool.fileList().length > 0) {
			return '<fmt:message key='jsdouble.photos.uploadPhotos.cancelUploadsMsg'/>';
		}
	}

	var uploadUrl = "<c:out value='${photoUploadServer}'/>/friend/photos/uploadPhotos.do?type=0&kval=<c:out value='${kval}' />&server=<%= com.friend.utils.ServerHost.hostName %>&albumId=" +
                  (document.upload.type.value == 1 ? -1 : document.upload.albumId.value) +
                  "&timestamp=<c:out value='${Hi5Session.timestamp}'/>&setCode=true";
	var uploadComplete = false;

	var FilesListState = {
		name: 'FilesListState',

		init: function() {
			log('> FileListState.init'); indentLevel++;

			$('upload-button').style.backgroundImage = 'url(http://images.hi5.com/images/buttons/orange-button.jpg)';
			$('upload-button').innerHTML = '<fmt:message key="message.photos.uploadPhotos.buttonUploadPhotos"/>';

			var fileList = uploadTool.fileList();

			$('files').innerHTML = '';
			for (i = 0, j = 0; i < fileList.length; i++) {
				$('files').appendChild(fileRow(i, j, fileList[i].name, fileList[i].size));
				if (fileList[i].size > 10000000) {
					$('listitem-row-' + i).style.color = '#b72121';
					$('listitem-row-' + i).style.cursor = 'help';
					$('listitem-row-' + i).title = '<fmt:message key='message.photos.uploadPhotos.maxPhotoFileSize'/>';
					$('listitem-name-' + i).style.backgroundImage = 'url(http://images.hi5.com/images/icons/_/update_failure.gif)';

					uploadTool.removeItemAt(j);
				} else {
					j += 1;
				}
			}

			$('upload-div').style.visibility = 'visible';
			$('upload-progress').style.left = '0px';
			$('upload-progress').style.width = '0px';
			$('upload-button').innerHTML = '<fmt:message key='message.photos.uploadPhotos.buttonUploadPhotos'/>';

			if (fileList.length > 7) {
				$('add-more').style.display = 'none';
				$('add-more2').style.visibility = 'visible';
			} else {
				$('add-more').style.display = 'block';
				$('add-more2').style.visibility = 'hidden';
			}

			if (fileList.length == 0) {
				$('files').innerHTML = '<div class="item-row" style="padding: 5px 0;"><fmt:message key='message.photos.uploadPhotos.noFilesSelected'/></div>';
			}

			$('files-list').scrollTop = $('files-list').scrollHeight;

			indentLevel--; log('< FileListState.init');
		},

		mainAction: function() {
			uploadFiles();
		}
	};

	var UploadFilesState = {
		name: 'UploadFilesState',

		init: function() {
			log('> UploadFilesState.init'); indentLevel++;

			FilesListState.init();
			$('add-more').style.display = 'none';
			$('add-more2').style.visibility = 'hidden';

      fileUploadCount = 0;

      var indexes = [];
			for (var i = indexOffset; i < uploadTool.fileList().length; i++)
				indexes.push(i);
		uploadUrl = '<c:out value="${photoUploadServer}"/>/friend/photos/uploadPhotos.do?type=' + document.upload.type.value +
		 '&kval=<c:out value='${kval}' />&server=<%= com.friend.utils.ServerHost.hostName %>&albumId=' + (document.upload.type.value == 1 ? -1 : document.upload.albumId.value) +
		 '&albumName=' + document.upload.albumName.value + '&timestamp=<c:out value="${Hi5Session.timestamp}"/>&setCode=true';
		 log(document.upload.albumName.value);
//		 alert((document.upload.type.value == 1 ? -1 : document.upload.albumId.value));
      uploadTool.uploadFiles(indexes, uploadUrl);

      indentLevel--; log('< UploadFilesState.init');
		},

		mainAction: function() {
			cancelUpload();
		}
	};

	var UploadErrorState = {
		name: 'UploadErrorState',

		init: function() {
			indexOffset = 0;
			continueAlbum = false;
			uploadTool.removeAll();

			$('upload-button').innerHTML = 'Upload Photos';
			$('upload-button').disabled = 'disabled';
			$('add-more2').style.visibility = 'visible';
		},

		mainAction: function() {
			uploadFiles();
		}
	}

	var UploadCompleteState = {
		name: 'UploadCompleteState',

		init: function() {
			log('> UploadCompleteState.init'); indentLevel++;

			indexOffset = 0;
			continueAlbum = false;
			uploadTool.removeAll();

			$('upload-button').style.backgroundImage = 'url(http://images.hi5.com/images/buttons/blue-button.jpg)';
			$('upload-button').innerHTML = '<fmt:message key='message.photos.uploadPhotos.buttonTagFriends'/>';

			if (uploadTool.fileList().length > 7) {
				$('add-more').style.display = 'none';
				$('add-more2').style.visibility = 'visible';
			} else {
				$('add-more').style.display = 'block';
				$('add-more2').style.visibility = 'hidden';
			}

      if (fileUploadCount > 0) {
        window.location = '/friend/photos/displayManageNewPhotos.do?ownerId=<c:out value='${album.ownerId}'/>&albumId=' +
                          (document.upload.type.value == 1 ? -1 : document.upload.albumId.value) +
                          '&fileUploadCount=' + fileUploadCount;
      }

      indentLevel--; log('< UploadCompleteState.init');
		},

		mainAction: function() {
			window.location = '/friend/photos/displayManageNewPhotos.do?ownerId=<c:out value='${album.ownerId}'/>&albumId=' +
                        (document.upload.type.value == 1 ? -1 : document.upload.albumId.value) +
                        '&fileUploadCount=' + fileUploadCount;
		}
	}

	/* ---------------------------------------------------------------------------------------------- */

	function browseFiles() {
		var imageTypes = new Object();
		imageTypes.description = '(*.jpg,*.jpeg,*.gif,*.png,*.bmp)';
		imageTypes.extension = '*.jpg;*.jpeg;*.gif;*.png;;*.bmp';

		uploadTool.browseFiles([imageTypes]);
	}

	function uploadFiles() {
		setState(UploadFilesState);
	}

	function cancelUpload() {
		uploadTool.cancelUploadDownload();
		setState(FilesListState);
	}

	/* ---------------------------------------------------------------------------------------------- */

	function MultiPowUpload_onSelect() {
		log('> onSelect'); indentLevel++;

		setState(FilesListState);

		indentLevel--; log('< onSelect');
	}

	function MultiPowUpload_onProgress(type, index, fileBytesLoaded, fileBytesLength, totalBytesLoaded, totalBytesLength) {
		var percentDone = new Number((totalBytesLoaded / totalBytesLength));

		$('upload-progress').style.left = 206 * percentDone + 'px';
		$('upload-progress').style.width = 206 * (1 - percentDone) + 'px';
		$('upload-button').innerHTML = (percentDone * 100).toFixed(0) + '%';
	}

	function MultiPowUpload_onError(type, index, error) {
		log('> onError ' + (indexOffset)); indentLevel++;

		$('listitem-row-' + (indexOffset)).style.color = '#b72121';
		$('listitem-row-' + (indexOffset)).style.cursor = 'help';
		if (error.match('521'))
			$('listitem-row-' + (indexOffset)).title = 'This file is not a valid image';
		else if (error.match('520'))
			$('listitem-row-' + (indexOffset)).title = 'Photo services is temporarily down';
		else
			$('listitem-row' + (indexOffset)).title = 'Sorry, an unexpeced error occured';
		$('listitem-name-' + (indexOffset)).style.backgroundImage = 'url(http://images.hi5.com/images/icons/_/update_failure.gif)';

		indexOffset += 1;

		var indexes = [];
		for (var i = indexOffset; i < uploadTool.fileList().length; i++)
			indexes.push(i);

		if (indexOffset < uploadTool.fileList().length)
			uploadTool.uploadFiles(indexes, uploadUrl);
		else {
			if (continueAlbum == true)
				setState(UploadCompleteState);
			else
				setState(UploadErrorState);
		}

		indentLevel--; log('< onError');
	}

	function MultiPowUpload_onComplete(type, index) {
    log('> onComplete ' + (indexOffset)); indentLevel++;

    fileUploadCount++;

    $('listitem-name-' + (indexOffset)).style.backgroundImage = 'url(http://images.hi5.com/images/icons/_/update_success.gif)';

		indexOffset += 1;
		continueAlbum = true;

		if (uploadTool.fileList().length == indexOffset)
			setState(UploadCompleteState)

    indentLevel--; log('< onComplete');
	}

	/* ---------------------------------------------------------------------------------------------- */

	function fileRow(id, index, filename, filesize) {
		var row = document.createElement('div');
		var name = document.createElement('div');
		var size = document.createElement('div');
		var close = document.createElement('div');

		row.className = 'item-row';
		row.id = 'listitem-row-' + id;
		name.className = 'list-name item-column';
		name.id = 'listitem-name-' + id;
		size.className = 'item-size item-column';
		close.className = 'item-close item-column';
		close.id = 'listitem-close-' + id;
		close.title = '<fmt:message key='jsdouble.message.photos.uploadPhotos.removePhotoFromList'/>';

		var sizeString = filesize > 1000000 ? (filesize / 1000000).toFixed(1) + '<fmt:message key='jsdouble.message.photos.uploadPhotos.fileSizeMB'/>' :
						 filesize > 1000 ? (filesize / 1000).toFixed(1) + '<fmt:message key='jsdouble.message.photos.uploadPhotos.fileSizeKB'/>' :
						 filesize + "<fmt:message key='jsdouble.message.photos.uploadPhotos.fileSizeB'/>";

		name.appendChild(document.createTextNode(filename));
		size.appendChild(document.createTextNode(sizeString));
		close.appendChild(document.createTextNode('\u00a0'));

		var clear = document.createElement('div');
		clear.style.clear = 'left';

		row.appendChild(name);
		row.appendChild(size);
		row.appendChild(close);
		row.appendChild(clear);

		row.onmouseover = function() {
			this.className = 'item-row selected';
			if (this.previousSibling)
				this.previousSibling.className = 'item-row previous';
		}

		row.onmouseout = function() {
			this.className = 'item-row';
			if (this.previousSibling)
				this.previousSibling.className = 'item-row';
		}

		close.onclick = function() {
			uploadTool.removeItemAt(index);
			MultiPowUpload_onSelect();
		}

		return row;
	}
</script>

<script type="text/javascript">
	function createAlbum() {
		document.getElementById('select-album').style.display = 'none';
		document.getElementById('create-album').style.display = '';
		document.upload.type.value = '1';
	}

	function selectAlbum() {
		document.getElementById('create-album').style.display = 'none';
		document.getElementById('select-album').style.display = '';
		document.upload.type.value = '0';
	}
</script>
