class MemberService {

    boolean transactional = true

    def getFriends(member) {
        //MemberFriend.findAllByMember(member)*.friend // Causes all friends to load
        MemberFriend.findAllByMember(member)
    }

}
