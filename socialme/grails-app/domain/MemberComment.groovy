class MemberComment {

    Member member
    Member sender
    Date   commentDate
    String message

    static constraints = {
        member()
        sender()
        message(blank: false)
        commentDate()
    }

    static mapping = {
        //sort "comment_date"
        //commentDate sort: "desc"
        //sort comment_date: "desc"
        //comment_date sort: "desc"
        commentDate index: "comment_date"
    }

}
