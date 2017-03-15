enum UpdateType { STATUS, IDEA }

class MemberUpdate {

    Member member
    UpdateType type
    String template
    String iconURL
    Date   createdDate
    String link1, link2
    String url1, url2
    String title
    String thumbURL
    String message

    static constraints = {
        member()
        template()
        iconURL()
        link1(nullable: true)
        link2(nullable: true)
        url1(nullable: true)
        url2(nullable: true)
        title(nullable: true, blank: false)
        thumbURL(nullable: true, blank: false)
        message(nullable: true, blank: false)
    }

    def getFormattedString() {
        template.replaceFirst(/\{0\}/, "<a href=\"${url1}\">${link1}</a>").replaceFirst(/\{1\}/, "<a href=\"${url2}\">${link2}</a>")
    }

    def getMessageSnippet() {
        message
    }

    def getThumbnailURL() {
        thumbURL
    }

}
