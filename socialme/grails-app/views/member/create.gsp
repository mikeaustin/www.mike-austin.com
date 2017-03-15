

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create Member</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Member List</g:link></span>
        </div>
        <div class="body">
            <h1>Create Member</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${memberInstance}">
            <div class="errors">
                <g:renderErrors bean="${memberInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="account">Account:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'account','errors')}">
                                    <g:select optionKey="id" from="${Account.list()}" name="account.id" value="${memberInstance?.account?.id}" ></g:select>
                                </td>
                            </tr> 
                        
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
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="status">Status:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:memberInstance,field:'status','errors')}">
                                    <input type="text" id="status" name="status" value="${fieldValue(bean:memberInstance,field:'status')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
