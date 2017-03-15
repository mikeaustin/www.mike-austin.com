class MemberController {

    def scaffold = Member

    def index = { forward(action: "list") }

    def memberService, eventService

    def show = {
        def member  = Member.get(params.id)
        def events  = eventService.getEvents(member.id)
        def updates = MemberUpdate.findAllByMember(member, [sort: 'createdDate', order: 'desc'])

        //def feed = new XmlSlurper().parse("http://mike-austin.com/blog/atom.xml")
        //feed.entry[0..1].each { println it }

        if (member) {
            //member.comments = Comment.list([sort: "commentDate", order: "desc", max: 10])
            return [member: member, updates: updates, events: events]
        }
        else {
            flash.message = "Member not found with id ${params.id}"
            redirect(action: list)
        }
    }

    def favajax = {
        def friend = new MemberFriend(member: session.member, friend: Member.get(params.id))

        if (!friend.hasErrors() && friend.save()) {
            render "Buddy added"
        } else {
            friend.errors.each { println it }
            response.sendError(500, "Allready a friend")
        }
    }

    def setStatus = {
        def member = Member.get(session.member.id)
        member.status = params.status

        if (member.save()) {
            def update = new MemberUpdate(member: member,
                               type: params.type == "wants_to" ? UpdateType.IDEA : UpdateType.STATUS,
                           template: "{0} ${member.status}",
                        createdDate: new Date(),
                              link1: member.name,
                            iconURL: "/socialme/images/icons/user_comment.png").save()
println update.validate()
        }

        render(template: "status", model: [member: member])
    }

    def room = {
        def member = Member.get(params.id)
        def items = MemberRoom.findAllByMember(member)

        [member: member, items: items]
    }

}
