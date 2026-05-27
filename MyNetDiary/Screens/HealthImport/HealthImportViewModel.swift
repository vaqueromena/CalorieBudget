final class HealthImportViewModel {
    private let session: UserSession
    private let healthKitService: HealthKitService

    var onImportComplete: (() -> Void)?

    init(session: UserSession, healthKitService: HealthKitService) {
        self.session = session
        self.healthKitService = healthKitService
    }

    func importHealthData() async {
        do {
            try await healthKitService.requestAuthorization()
        } catch {
            await MainActor.run { onImportComplete?() }
            return
        }
        // Independent try? per fetch: one failure does NOT discard the others.
        // (async let throws-all-or-nothing, so we use sequential try? instead.)
        let weight = try? await healthKitService.fetchWeight()
        let height = try? await healthKitService.fetchHeight()
        let dob    = try? await healthKitService.fetchDateOfBirth()

        if let w = weight { session.weightKg = w;       session.healthKitWeight = w }
        if let h = height { session.heightMeters = h;   session.healthKitHeight = h }
        if let d = dob    { session.dateOfBirth = d;    session.healthKitDateOfBirth = d }

        await MainActor.run { onImportComplete?() }
    }

    func skip() {
        onImportComplete?()
    }
}
