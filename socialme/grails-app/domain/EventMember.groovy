enum Status { YES, MAYBE, NO }

class EventMember {

    Member member
    Event  event
    Status status

    String toString() {
        "${member.name} : ${event.name}"
    }

}
