class EventCommand {

    Long    id
    String  name
    String  venue
    String  location
    String  address
    Date    startDate
    Member  owner
    String  notes
    Boolean confirmed = false

    static hasMany = [members: EventMember]

    static constraints = {
        name(blank: false)
        venue(blank: false)
        location(blank: false)
        address(nullable: true)
        startDate()
        notes(nullable: true, maxSize: 1000)
        confirmed()
    }

    static mapping = {
        table "_event"
        batchSize 10
        startDate index: "start_date"
    }

    String toString() {
        name
    }

}

class EventController {

    def scaffold = Event
    def memberService, eventService

    def test = {
        def event = new EventCommand(name: params.name, venue: params.venue, location: params.location, startDate: params.startDate)

        render event.name
    }

    def index = {
        println "-- my friends ------"
        MemberFriend.findAllByMember(session.member, [fetch: [friend: "eager"]])
        println "--------------------"

        render "test"
    }

    def list = {
        println "-- my friends ------"
        def friends = MemberFriend.findAllByMember(session.member)
        println "--------------------"
        def events, friendEvents

        println "-- my events -------"
        events = EventMember.findAllByMember(session.member, [fetch: [event: 'eager']])
        println "--------------------"

        if (friends) {
            println "-- friendEvents ----"
            friendEvents = EventMember.findAllByMemberInList(friends, [fetch: [event: 'eager']])
            println "--------------------"
        }

        if (friendEvents) {
            [events: events*.event, eventInstanceTotal: 0,
             friendEvents: friendEvents*.event]
        }
        else if (events) {
            [events: events*.event, eventInstanceTotal: 0]
        }
        else {
            [events: [], eventInstanceTotal: 0]
        }
    }

    def show = {
        def event = Event.get(params.id)
        def attendies = EventMember.findAllByEvent(event, [max: 10, fetch: [member: 'eager']])

        [event: event, attendies: attendies]
    }

    def showajax = {
        def event = Event.get(params.id)

        //render(template: "event", model: [event: event])
        [event: event]
    }

    def save = {
        def event = new Event(params)
        event.owner = session.member

        if (event.validate() && eventService.createEvent(event)) {
            def update = new MemberUpdate(member: event.owner,
                           template: "{0} created an event at ${event.venue}",
                        createdDate: new Date(),
                              link1: event.owner.name,
                               url1: createLink(controller: "member", id: event.owner.id),
                              title: event.name,
                               url2: createLink(controller: "event", id: event.id),
                            iconURL: "/socialme/images/icons/date.png")

            if (!update.save()) {
                update.errors.each { println it }
            }

            flash.message = "Event ${event.id} created"
            redirect(action: show, id: event.id)
        }
        else {
            render(view: 'create', model: [eventInstance: event])
        }
    }

}
