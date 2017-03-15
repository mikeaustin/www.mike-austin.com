class Event {

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
