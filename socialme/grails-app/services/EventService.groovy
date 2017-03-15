class EventService {

    boolean transactional = true

    def eventProvider

    def createEvent(event) {
        def member
        //def event = new Event(name: command.name, venue: command.venue, location: command.location, startDate: command.startDate, owner: command.owner)

        if (event.save()) {
            //command.id = event.id

            member = new EventMember(member: event.owner, event: event, status: Status.YES)

            if (member.save()) {
                return true
            }
        }

        return false
    }

    def getEvents(memberId) {
        //eventProvider.getEvents(memberId)

        //EventMember.findAll("from EventMember where member_id = ?", memberId)
        EventMember.findAllByMember(Member.get(memberId), [max: 10, fetch: [event: "eager"]])
    }

}
