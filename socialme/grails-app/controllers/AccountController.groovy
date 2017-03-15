class AccountController {

    def scaffold = Account

    def index = { forward(action: "list") }

    def login = {
        def account = Account.findWhere([email: params.email])

        if (account != null) {
            session.account = account

            def member = Member.findWhere([id: account.id])
            session.member = member

		redirect(url: request.getHeader("referer"))
        }
        else {
            response.sendError(500, "Login required")

            render("Failed to log in")
        }
    }

    def logout = {
        if (session.account) {
            session.account = null
            session.member = null
            session.invalidate()
        }

        render("Successfully logged out")
    }

}
