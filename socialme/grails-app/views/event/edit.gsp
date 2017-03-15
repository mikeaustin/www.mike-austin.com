

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit Event</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Event List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Event</g:link></span>
        </div>
        <div class="body">
            <h1>Edit Event</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${eventInstance}">
            <div class="errors">
                <g:renderErrors bean="${eventInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${eventInstance?.id}" />
                <input type="hidden" name="version" value="${eventInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'name','errors')}">
                                    <input type="text" id="name" name="name" value="${fieldValue(bean:eventInstance,field:'name')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="venue">Venue:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'venue','errors')}">
                                    <input type="text" id="venue" name="venue" value="${fieldValue(bean:eventInstance,field:'venue')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="location">Location:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'location','errors')}">
                                    <input type="text" id="location" name="location" value="${fieldValue(bean:eventInstance,field:'location')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="address">Address:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'address','errors')}">
                                    <input type="text" id="address" name="address" value="${fieldValue(bean:eventInstance,field:'address')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="startDate">Start Date:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'startDate','errors')}">
                                    <g:datePicker name="startDate" value="${eventInstance?.startDate}" ></g:datePicker>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="notes">Notes:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'notes','errors')}">
                                    <textarea rows="5" cols="40" name="notes">${fieldValue(bean:eventInstance, field:'notes')}</textarea>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="confirmed">Confirmed:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'confirmed','errors')}">
                                    <g:checkBox name="confirmed" value="${eventInstance?.confirmed}" ></g:checkBox>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="members">Members:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:eventInstance,field:'members','errors')}">
                                    
<ul>
<g:each var="m" in="${eventInstance?.members?}">
    <li><g:link controller="eventMember" action="show" id="${m.id}">${m?.encodeAsHTML()}</g:link></li>
</g:each>
</ul>
<g:link controller="eventMember" params="['event.id':eventInstance?.id]" action="create">Add EventMember</g:link>

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
