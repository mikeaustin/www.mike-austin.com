class IdeaListController {

    def scaffold = IdeaList

    def index = { forward(action: "list") }

}
