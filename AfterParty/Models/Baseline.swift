import Foundation

struct Baseline: Hashable, Sendable {
    var values: [HealthMetricKind: Double]

    func value(for kind: HealthMetricKind) -> Double {
        values[kind, default: 0]
    }

    static let mock = Baseline(values: [
        .heartRate: 67,
        .hrv: 55,
        .restingHeartRate: 65
    ])
}
