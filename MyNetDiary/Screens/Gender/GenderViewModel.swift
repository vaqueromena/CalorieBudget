final class GenderViewModel {
    private let session: UserSession

    var onContinue: (() -> Void)?

    init(session: UserSession) {
        self.session = session
    }

    func selectGender(_ gender: Gender) {
        session.gender = gender
    }

    func continueOnboarding() {
        onContinue?()
    }
}
