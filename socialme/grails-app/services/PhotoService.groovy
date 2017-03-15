class PhotoService {

    boolean transactional = true

    def getPhoto(id) {
        MemberPhoto.get(id)
    }

}
