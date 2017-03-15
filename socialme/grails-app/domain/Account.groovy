class Account {

    String email
    String password
    Date   registeredDate

    static constraints = {
        //name(blank: false)
        email(blank: false, unique: true)
        password(blank: false)
        registeredDate()
    }

    static hasMany = [profiles: Member]

}
