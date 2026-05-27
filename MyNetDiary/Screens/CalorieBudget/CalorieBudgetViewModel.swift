final class CalorieBudgetViewModel {
    private let session: UserSession

    var budgetText: String {
        let kcal = CalorieCalculator.bmr(
            gender: session.gender,
            ageInYears: session.ageInYears,
            weightKg: session.weightKg,
            heightMeters: session.heightMeters
        )
        return CalorieCalculator.formatted(kcal: kcal, useMetric: session.useMetricSystem)
    }

    init(session: UserSession) {
        self.session = session
    }
}
