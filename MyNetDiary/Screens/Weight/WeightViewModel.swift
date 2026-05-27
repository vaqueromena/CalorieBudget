import Foundation

private enum Constants {
    enum Strings {
        static let kgUnit = "kg"
        static let lbUnit = "lb"
        static let invalidNumberMessage = "Please enter a valid weight."
        static func outOfRangeMessage(minDisplay: Double, maxDisplay: Double, unit: String) -> String {
            "Please enter a weight between \(Int(minDisplay.rounded()))–\(Int(maxDisplay.rounded())) \(unit)."
        }
    }
    static let minKg: Double = 20
    static let maxKg: Double = 500
    static let lbPerKg: Double = 2.20462
}

enum WeightError: Error {
    case invalidNumber
    case outOfRange(minDisplay: Double, maxDisplay: Double, unit: String)

    var userMessage: String {
        switch self {
        case .invalidNumber:
            return Constants.Strings.invalidNumberMessage
        case .outOfRange(let minDisplay, let maxDisplay, let unit):
            return Constants.Strings.outOfRangeMessage(minDisplay: minDisplay, maxDisplay: maxDisplay, unit: unit)
        }
    }
}

final class WeightViewModel {
    private let session: UserSession

    var onContinue: (() -> Void)?

    var useMetricSystem: Bool {
        get { session.useMetricSystem }
        set { session.useMetricSystem = newValue }
    }

    var initialDisplayWeight: Double {
        useMetricSystem ? session.weightKg : session.weightKg * Constants.lbPerKg
    }

    init(session: UserSession) {
        self.session = session
    }

    func validateAndContinue(displayValue: Double?) -> WeightError? {
        guard let displayValue else { return .invalidNumber }
        let weightKg = useMetricSystem ? displayValue : displayValue / Constants.lbPerKg
        guard weightKg >= Constants.minKg && weightKg <= Constants.maxKg else {
            let minDisplay = useMetricSystem ? Constants.minKg : Constants.minKg * Constants.lbPerKg
            let maxDisplay = useMetricSystem ? Constants.maxKg : Constants.maxKg * Constants.lbPerKg
            let unit = useMetricSystem ? Constants.Strings.kgUnit : Constants.Strings.lbUnit
            return .outOfRange(minDisplay: minDisplay, maxDisplay: maxDisplay, unit: unit)
        }
        session.weightKg = weightKg
        onContinue?()
        return nil
    }

    func convertDisplayValue(_ value: Double, toMetric: Bool) -> Double {
        toMetric ? value / Constants.lbPerKg : value * Constants.lbPerKg
    }
}
