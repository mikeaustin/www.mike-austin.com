class MemberFriendController {

    def scaffold = MemberFriend

    def index = { forward(action: "list") }

    def list = {
        params.max = 10
        def friends = MemberFriend.findAllByMember(session.member)

        if (friends) {
            [friends: friends, friendsTotal: friends.count()]
        }
        else {
            [friends: [], friendsTotal: 0]
        }
    }

}
