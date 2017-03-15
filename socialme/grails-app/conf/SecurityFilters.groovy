class SecurityFilters {

    def filters = {
        authenticateFilter(controller: "*", action: "ajaxsave") {
            before = {
                println "\n${session}\n"
                if (session.account == null) {
                    //response.setHeader("WWW-Authenticate", "Digest realm=\"testrealm@socialme.us\", qop=\"auth,auth-int\", nonce=\"dcd98b7102dd2f0e8b11d0f600bfb0c093\", opaque=\"5ccc069c403ebaf9f0171e9517f40e41\"")
                    response.sendError(401, "Login required")

                    return false
                }
            }
        }

        updateFilter2(controller: "*", action: "*") {
            before = {
                println "${controllerName}: ${actionName}"
                println "------------------------------------------------------------"
            }
        }

        /*updateFilter(controller: "memberComment", action: "ajaxsave") {
            after = { model ->
                println "***\n" + model + "***\n"
                new MemberUpdate(member: model,
                               template: "{0} has given a comment",
                                  link1: model.name,
                                   url1: "/socialme/member/1",
                                iconURL: "http://images.hi5.com/images/icons/_/phtoto.png").save()
            }
        }*/
    }

}
