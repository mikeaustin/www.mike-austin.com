class IdeaController {

    def scaffold = Idea

    def index = { forward(action: "list") }

}
