class MemberCommentController {

    def scaffold = MemberComment

    def index = { forward(action: "list") }

    def ajaxsave = {
        def comment = new MemberComment(params)

        comment.sender = session.member;
        comment.commentDate = new Date();

        if (!comment.hasErrors() && comment.save()) {
            flash.message = "Comment ${comment.id} created"
            def comments = MemberComment.findAllByMember(comment.member)

            def update = new MemberUpdate(member: comment.member,
                           template: "{0} gave {1} a comment",
                        createdDate: new Date(),
                              link1: comment.sender.name,
                              link2: comment.member.name,
                               url1: createLink(controller: "member", id: comment.sender.id),
                               url2: createLink(controller: "member", id: comment.member.id),
                            message: comment.message,
                            iconURL: "/socialme/images/icons/comment.png")

            if (!update.save()) {
                update.errors.each { println it }
            }

            [member: session.member, comments: comments]
        }
        else {
            comment.errors.each { println it }
            render(template: "memberComments")
            //render(view: 'create', model: [commentInstance: comment])
        }
    }

    def xlist = {
        if (!params.max) params.max = 10
        [memberInstanceList: Comment.list(params, sort: "commentDate")]
    }

}
