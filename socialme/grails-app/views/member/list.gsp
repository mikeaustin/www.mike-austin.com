

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Member List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Member</g:link></span>
        </div>
        <div class="body">
            <h1>Member List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <th>Account</th>
                   	    
                   	        <g:sortableColumn property="name" title="Name" />
                        
                   	        <g:sortableColumn property="createdDate" title="Created Date" />
                        
                   	        <g:sortableColumn property="thumbnailURL" title="Thumbnail URL" />
                        
                   	        <g:sortableColumn property="location" title="Location" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${memberInstanceList}" status="i" var="memberInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${memberInstance.id}">${fieldValue(bean:memberInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:memberInstance, field:'account')}</td>
                        
                            <td>${fieldValue(bean:memberInstance, field:'name')}</td>
                        
                            <td>${fieldValue(bean:memberInstance, field:'createdDate')}</td>
                        
                            <td>${fieldValue(bean:memberInstance, field:'thumbnailURL')}</td>
                        
                            <td>${fieldValue(bean:memberInstance, field:'location')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${memberInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
