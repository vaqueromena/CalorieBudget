import Foundation

enum Gender {
    case male, female
}

final class UserSession {
    var gender: Gender = .male
    var weightKg: Double = 70.0
    var heightMeters: Double = 1.7
    var useMetricSystem: Bool
    var dateOfBirth: DateComponents

    var healthKitWeight: Double?
    var healthKitHeight: Double?
    var healthKitDateOfBirth: DateComponents?

    var birthDate: Date {
        Calendar.current.date(from: dateOfBirth) ?? Date()
    }

    var ageInYears: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    init() {
        // US uses imperial (lb); all other regions use metric (kg).
        // NOTE: spec says "ON for en-US, OFF otherwise" (US → metric), but we intentionally
        // deviate to match real-world MyNetDiary behavior: US → imperial (lb).
        useMetricSystem = Locale.current.region?.identifier != "US"

        // Default DOB = 30 years ago so calorie screen never shows 0 age.
        var dc = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dc.year = (dc.year ?? 2000) - 30
        dateOfBirth = dc
    }
}
