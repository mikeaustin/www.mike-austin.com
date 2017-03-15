<html>
    <body>
        <div class="body">
            <h2 class="first">Profile</h2>
            <g:if test="${flash.message}">
	            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${memberInstance}">
	            <div class="errors">
	                <g:renderErrors bean="${memberInstance}" as="list" />
	            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${memberInstance?.id}" />
                <input type="hidden" name="version" value="${memberInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'name','errors')}">
                                    <input type="text" maxlength="15" id="name" name="name" value="${fieldValue(bean:memberInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="createdDate">Created Date:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'createdDate','errors')}">
                                    <g:datePicker name="createdDate" value="${memberInstance?.createdDate}" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thumbnailURL">Thumbnail URL:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'thumbnailURL','errors')}">
                                    <input type="text" id="thumbnailURL" name="thumbnailURL" value="${fieldValue(bean:memberInstance,field:'thumbnailURL')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="location">Location:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'location','errors')}">
                                    <input type="text" id="location" name="location" value="${fieldValue(bean:memberInstance,field:'location')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="interests">Interests:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'interests','errors')}">
                                    <textarea rows="5" cols="40" name="interests">${fieldValue(bean:memberInstance, field:'interests')}</textarea>
                                </td>
                            </tr> 
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
