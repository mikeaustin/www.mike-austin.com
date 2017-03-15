class MemberRoomController {

    def scaffold = MemberRoom

    def index = { forward(action: "list") }

}
