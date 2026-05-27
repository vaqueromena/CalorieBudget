import HealthKit

enum HealthKitError: Error {
    case unavailable
    case denied
}

final class HealthKitService {
    private let store = HKHealthStore()

    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

    func requestAuthorization() async throws {
        guard isAvailable else { throw HealthKitError.unavailable }
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
        ]
        try await store.requestAuthorization(toShare: [], read: readTypes)
    }

    func fetchWeight() async throws -> Double? {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        return try await fetchMostRecentSample(type: type, unit: .gramUnit(with: .kilo))
    }

    func fetchHeight() async throws -> Double? {
        let type = HKObjectType.quantityType(forIdentifier: .height)!
        return try await fetchMostRecentSample(type: type, unit: .meter())
    }

    func fetchDateOfBirth() async throws -> DateComponents? {
        try store.dateOfBirthComponents()
    }

    private func fetchMostRecentSample(type: HKQuantityType, unit: HKUnit) async throws -> Double? {
        try await withCheckedThrowingContinuation { continuation in
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit)
                continuation.resume(returning: value)
            }
            self.store.execute(query)
        }
    }
}
