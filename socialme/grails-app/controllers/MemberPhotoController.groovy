class MemberPhotoController {

    def scaffold = MemberPhoto

    def index = { forward(action: "list") }

    def list = {
        params.max = 10
        def photos = MemberPhoto.findAllByMember(session.member)

        if (photos) {
            [photos: photos, photosTotal: photos.count()]
        }
        else {
            [photos: [], photosTotal: 0]
        }
    }

    def showajax = {
        def photo = MemberPhoto.get(params.id)

        render("<div style=\"margin-bottom: 5px;\">${photo?.description}</div><img src=\"${photo.photoURL}\" width=\"480\"/>")
    }

}
