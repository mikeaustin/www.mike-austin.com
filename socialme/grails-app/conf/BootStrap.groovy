class BootStrap {

     def init = { servletContext ->
        def account1 = new Account(email: "tester@socialme.us",
                                password: "12345",
                          registeredDate: new Date()).save()

        def account2 = new Account(email: "tester2@socialme.us",
                                password: "12345",
                          registeredDate: new Date()).save()

        def member1 = new Member(account: account1,
                                    name: "Roxxor",
                             createdDate: new Date(),
                            thumbnailURL: "http://photos3.hi5.com/0080/973/982/E.w2gD973982-01.jpg",
                                location: "San Bruno, CA",
                               interests: "Roxxin' the axe!").save()

        def member2 = new Member(account: account1,
                                    name: "Slayer",
                             createdDate: new Date(),
                            thumbnailURL: "http://photos4.hi5.com/0075/454/035/eZf3hV454035-01.jpg").save()

        def member3 = new Member(account: account2,
                                    name: "The Dude with A",
                             createdDate: new Date(),
                            thumbnailURL: "http://photos4.hi5.com/0078/283/643/NHB0Gp283643-01.jpg",
                                location: "Somewhere out there",
                               interests: "Having long names").save()

        new MemberFriend(member: member1, friend: member2, notes: "Notes, yeah").save()
        new MemberFriend(member: member1, friend: member3, notes: "This dude rocks the house, yo!").save()

        new MemberUpdate(member: member1,
                       template: "{0} has added a new photo",
                          link1: "Roxxor",
                           url1: "/socialme/member/1",
                        iconURL: "http://images.hi5.com/images/icons/_/phtoto.png").save()

        new MemberPhoto(member: member1, thumbURL: "http://photos2.hi5.com/0057/758/669/h4A6Bc758669-01.jpg", photoURL: "http://photos2.hi5.com/0057/758/669/h4A6Bc758669-02.jpg",
         description: "Bobo Fett meets his arch enemy, who holds the green ball of death").save()
        new MemberPhoto(member: member1, thumbURL: "http://photos3.hi5.com/0030/110/690/ZoGwhE110690-01.jpg", photoURL: "http://photos3.hi5.com/0030/110/690/ZoGwhE110690-02.jpg").save()
        new MemberPhoto(member: member1, thumbURL: "http://photos4.hi5.com/0029/854/559/NJXdCG854559-01.jpg", photoURL: "http://photos4.hi5.com/0029/854/559/NJXdCG854559-02.jpg").save()

        def event1 = new Event(name: "See Justice in Oakland",
                              venue: "Oakland Coliseum",
                           location: "Oakland, CA",
                          startDate: new Date(),
                              owner: member1).save()

        def event2 = new Event(name: "See Metallica in San Francisco",
                              venue: "The Warfield",
                           location: "San Francisco, CA",
                            address: "982 Market St.",
                          startDate: new Date(),
                              owner: member1,
                              notes: "Bring a bathing suit!!").save()

        new EventMember(member: member1, event: event1, status: Status.YES).save()
        new EventMember(member: member1, event: event2, status: Status.YES).save()

        new Place(name: "The Warfield", location: "San Francisco, CA", address: "982 Market St.").save()
        new Place(name: "Oakland Coliseum", location: "Oakland, CA").save()

        new MemberRoom(member: member1, objectURL: "http://socialme.us:8080/socialme/images/assets/black_guitar-128x128.png", posX: 350, posY: 150).save()
        new MemberRoom(member: member1, objectURL: "http://socialme.us:8080/socialme/images/assets/cat_64.png", posX: 100, posY: 150).save()
        new MemberRoom(member: member1, objectURL: "http://socialme.us:8080/socialme/images/assets/alien_128.png", posX: 180, posY: 170).save()
     }

     def destroy = {
     }

}
