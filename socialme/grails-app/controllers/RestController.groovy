import static org.apache.commons.lang.StringUtils.*
import org.codehaus.groovy.runtime.InvokerHelper
import org.codehaus.groovy.grails.commons.GrailsDomainClass

class RestController {

   def defaultAction = "show"

    private GrailsDomainClass domainClass
    private String domainClassName

    def beforeInterceptor = {
        domainClassName = capitalize(params.domain)
        domainClass     = grailsApplication.getArtefact("Domain", domainClassName)
    }

    def show = {
        def result

        if (params.id) {
            result = InvokerHelper.invokeStaticMethod(domainClass.getClazz(), "get", params.id)
        } else {
            params.max = 10
            result = InvokerHelper.invokeStaticMethod(domainClass.getClazz(), "list", params)
        }

        render result.encodeAsJSON()
    }

}
