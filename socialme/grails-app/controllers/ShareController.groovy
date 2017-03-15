class ShareController {

    def scaffold = Share

    def index = { forward(action: "share") }

    def share = {
        def url = new URL(params.url)
        def query = url.getQuery()
        def thumb

        if (query) {
            def qparams = query.split("&")
            def mparams = [:]
            qparams.each() { param ->
                def mapping = param.split("=")
                mparams[mapping[0]] = mapping.size() > 1 ? mapping[1] : ""
            }

            if (url.getHost() == "www.youtube.com") {
                thumb = "http://i3.ytimg.com/vi/${mparams['v']}/default.jpg"
            }
        }

        def share = new Share(member: session.member,
                               title: params.title,
                                 url: params.url,
                            thumbURL: thumb,
                             message: params.message == "" ? null : params.message)

        if (!share.hasErrors() && share.save()) {
            def updType  = UpdateType.STATUS
            def template = "{0} has shared a link";
            def iconURL  = "/socialme/images/icons/page_link.png";

            switch(url.getHost()) {
                case "www.youtube.com":
                    template = "{0} has shared a YouTube video"
                    iconURL  = "/socialme/images/icons/film.png";
                break;
                case "www.yelp.com":
                    updType  = UpdateType.IDEA
                    template = "{0} has shared a Yelp location"
                    iconURL  = "/socialme/images/icons/world_link.png"
                break;
            }

            def update = new MemberUpdate(member: share.member,
                               type: updType,
                           template: template,
                        createdDate: new Date(),
                              link1: share.member.name,
                               url1: createLink(controller: "member", id: share.member.id),
                              title: share.title,
                               url2: share.url,
                           thumbURL: share.thumbURL,
                            message: share.message,
                            iconURL: iconURL).save()

            redirect(url: params.url)
            render "Share saved successfully"
        }
        else {
            println share.errors
            render "Share not saved"
        }

        //render "<a href='${params.url}'>${params.title}</a><br/><img src='http://i3.ytimg.com/vi/${mparams['v']}/default.jpg'/>"
    }

}

/*

<title>The Big Lebowski - F_cking Short Version</title>
<span class="description">F count of The Big Lebowski I think is 281, this isn't all of them! </span>

http://www.youtube.com/watch?v=RqtgfjkB6Pg&feature=rec-HM-rev-rn

http://i3.ytimg.com/vi/RqtgfjkB6Pg/default.jpg

http://www.youtube.com/watch?v=RqtgfjkB6Pg

javascript:var message=prompt('Optional comment:', '');if(message != null){window.location='http://socialme.us:8080/socialme/share?url='+encodeURIComponent(document.location)+'&title='+encodeURIComponent(document.title)+(message != ""?'&message='+encodeURIComponent(message):'')};void(0);

javascript:(function(){var message=prompt('Optional comment:', '');if(message != null){window.location='http://socialme.us:8080/socialme/share?url='+encodeURIComponent(document.location)+'&title='+encodeURIComponent(document.title)+(message != ""?'&message='+encodeURIComponent(message):'')};void(0);}());

javascript:(function(){var $=document.getElementById;var message=prompt('Optional comment:','');if(message!=null){window.location='http://socialme.us:8080/socialme/share?url='+encodeURIComponent(document.location)+'&title='+encodeURIComponent(document.title)+(message!=""?'&message='+encodeURIComponent(message):'')};void(0);}());

*/
