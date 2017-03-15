

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Event List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Event</g:link></span>
        </div>
        <div class="body">
            <h1>Event List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="name" title="Name" />
                        
                   	        <g:sortableColumn property="venue" title="Venue" />
                        
                   	        <g:sortableColumn property="location" title="Location" />
                        
                   	        <g:sortableColumn property="address" title="Address" />
                        
                   	        <g:sortableColumn property="startDate" title="Start Date" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${eventInstanceList}" status="i" var="eventInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${eventInstance.id}">${fieldValue(bean:eventInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:eventInstance, field:'name')}</td>
                        
                            <td>${fieldValue(bean:eventInstance, field:'venue')}</td>
                        
                            <td>${fieldValue(bean:eventInstance, field:'location')}</td>
                        
                            <td>${fieldValue(bean:eventInstance, field:'address')}</td>
                        
                            <td>${fieldValue(bean:eventInstance, field:'startDate')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${eventInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
