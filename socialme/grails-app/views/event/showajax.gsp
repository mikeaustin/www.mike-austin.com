<g:setProvider library="jquery"/>

<g:render template="summary" model="[events: [event]]"/>

<div class="item">
    <g:if test="${!event.confirmed}">
        <span class="after warn">This event has NOT yet been confirmed</span>
    </g:if>
    <a href="#">Driving Directions</a>
</div>

${event.notes}

<div id="map" style="width: 480px; height: 270px; margin-top: 5px;"></div>
