class Share {

    Member member
    String title
    String url
    String thumbURL
    String message

    static constraints = {
        member()
        title()
        url()
        thumbURL(nullable: true)
        message(nullable: true)
    }

}
