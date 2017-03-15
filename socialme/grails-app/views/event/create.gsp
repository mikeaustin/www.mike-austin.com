<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <title>Create Event</title>         
    </head>
    <body>
        <div class="body">
            <h2>Create Event</h2>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${eventInstance}">
            <div class="errors">
                <g:renderErrors bean="${eventInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
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
