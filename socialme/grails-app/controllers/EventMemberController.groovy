class EventMemberController {

    def scaffold = EventMember

    def index = { forward(action: "list") }

    def save = {
        def member = new EventMember(params)

        //member.eventName = member.event.name
        //member.memberName = member.member.name

        if(!member.hasErrors() && member.save()) {
            flash.message = "EventMember ${member.id} created"
            redirect(action: show, id: member.id)
        }
        else {
            render(view: 'create', model: [memberInstance: member])
        }
    }

    def xindex = {
        if (!params.max) params.max = 10
        def members = Members.list(params)

        render(view: 'list', model: [membersInstance: members])
    }

}
