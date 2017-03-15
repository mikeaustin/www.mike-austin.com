class PlaceController {

    def scaffold = Place

    def index = { forward(action: "list") }

}
