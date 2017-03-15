class MemberFriend {

    Member member
    Member friend
    String notes

    static constraints = {
        member()
        friend(unique: 'member')
        notes(nullable: true)
    }

}
