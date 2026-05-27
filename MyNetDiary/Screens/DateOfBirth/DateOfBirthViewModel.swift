import Foundation

private enum Constants {
    enum Strings {
        static let invalidDateText = "Please select a valid date of birth."
        static func tooYoungMessage(minAge: Int) -> String {
            "This app is available for users aged \(minAge) and above."
        }
    }
    static let minAge = 13
    static let maxAgeYears = 120
}

enum DateOfBirthError: Error {
    case tooYoung(minAge: Int)
    case invalidDate

    var userMessage: String {
        switch self {
        case .tooYoung(let minAge):
            return Constants.Strings.tooYoungMessage(minAge: minAge)
        case .invalidDate:
            return Constants.Strings.invalidDateText
        }
    }
}

final class DateOfBirthViewModel {
    private let session: UserSession
    private var pendingDate: Date?

    var onContinue: (() -> Void)?

    var initialDate: Date {
        Calendar.current.date(from: session.dateOfBirth) ?? maximumDate
    }

    var maximumDate: Date {
        Calendar.current.startOfDay(for: Date())
    }

    var minimumDate: Date {
        Calendar.current.date(byAdding: .year, value: -Constants.maxAgeYears, to: maximumDate) ?? maximumDate
    }

    init(session: UserSession) {
        self.session = session
    }

    func setDate(_ date: Date) -> Int {
        pendingDate = date
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
    }

    func validateAndContinue() -> DateOfBirthError? {
        guard let date = pendingDate ?? Calendar.current.date(from: session.dateOfBirth) else {
            return .invalidDate
        }
        guard date >= minimumDate && date <= maximumDate else {
            return .invalidDate
        }
        let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        guard age >= Constants.minAge else {
            return .tooYoung(minAge: Constants.minAge)
        }
        session.dateOfBirth = Calendar.current.dateComponents([.year, .month, .day], from: date)
        onContinue?()
        return nil
    }
}
