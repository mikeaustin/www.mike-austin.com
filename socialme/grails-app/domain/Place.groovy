class Place {

    String name
    String address
    String location

    static constraints = {
        name()
        address(nullable: true)
        location(nullable: true)
    }

}
