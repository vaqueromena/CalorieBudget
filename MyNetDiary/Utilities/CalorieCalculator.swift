import Foundation

private enum Constants {
    enum Strings {
        static let kJUnit = "kJ"
        static let kcalUnit = "kcal"
    }
    static let pa: Double = 1.0
    static let kcalToKj: Double = 4.184

    // Male BMR formula: 662 - ageCoeff*age + PA*(weightCoeff*weight + heightCoeff*height)
    static let maleConstant: Double = 662
    static let maleAgeCoeff: Double = 9.53
    static let maleWeightCoeff: Double = 15.91
    static let maleHeightCoeff: Double = 539.6

    // Female BMR formula: 354 - ageCoeff*age + PA*(weightCoeff*weight + heightCoeff*height)
    static let femaleConstant: Double = 354
    static let femaleAgeCoeff: Double = 6.91
    static let femaleWeightCoeff: Double = 9.36
    static let femaleHeightCoeff: Double = 726.0
}

enum CalorieCalculator {
    static func bmr(gender: Gender, ageInYears: Int, weightKg: Double, heightMeters: Double) -> Double {
        let age = Double(ageInYears)
        let result: Double
        switch gender {
        case .male:
            result = Constants.maleConstant
                - Constants.maleAgeCoeff * age
                + Constants.pa * (Constants.maleWeightCoeff * weightKg + Constants.maleHeightCoeff * heightMeters)
        case .female:
            result = Constants.femaleConstant
                - Constants.femaleAgeCoeff * age
                + Constants.pa * (Constants.femaleWeightCoeff * weightKg + Constants.femaleHeightCoeff * heightMeters)
        }
        return max(0, result)
    }

    static func formatted(kcal: Double, useMetric: Bool) -> String {
        if useMetric {
            let kj = Int((kcal * Constants.kcalToKj).rounded())
            return "\(kj) \(Constants.Strings.kJUnit)"
        } else {
            return "\(Int(kcal.rounded())) \(Constants.Strings.kcalUnit)"
        }
    }
}
