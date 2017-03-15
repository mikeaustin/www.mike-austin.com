class UrlMappings {

    static mappings = {
        /*"/$controller/$action?/$id?" {
            constraints {
                // apply constraints here
            }

        }*/

        "/" (view: "/index")

        "/$controller" (action: "index") {
            constraints {
            }

        }

        "/$controller/$action" {
            constraints {
            }

        }

        "/$controller/$id" (action: "show") {
            constraints {
                id(matches: /\d*/)
            }

        }

        "/$controller/$id/$action" {
            constraints {
                id(matches: /\d*/)
            }

        }

        "/rest/$domain/$id?" {
            controller = "rest"
            action = [GET: "show"]
        }

        "500" (view: '/error')
    }

}
