class Member {

    Account account
    String  name
    Date    createdDate
    String  thumbnailURL
    String  location
    String  interests
    String  status

    static hasMany  = [friends: MemberFriend, comments: MemberComment, events: EventMember, photos: MemberPhoto, updates: MemberUpdate]
    static mappedBy = [friends: "member", comments: "member", events: "member"]

    static constraints = {
        account()
        name(blank: false, size: 0..15)
        createdDate()
        thumbnailURL(nullable: true)
        location(nullable: true)
        interests(nullable: true, widget: 'textarea')
        status(nullable: true)
        //buddies()
        //events()
    }

    static mapping = {
        account(lazy: true)
    }

    /*static mapping = {
        comments sort: "comment_date", order: "desc"
    }*/

    /*Set getComments() {
        MemberComment.findAllByMember(this, [sort: "commentDate", order: "desc"])
    }*/

    def isFriend(friend) {
        MemberFriend.findByMemberAndFriend(this, friend) != null
    }

    String toString() {
        name
    }

}
