import grails.util.*

// Place your Spring DSL code here

beans = {
    switch(GrailsUtil.environment) {
        case "development":
            eventProvider(LocalEventProvider)
        break;
    }
}
