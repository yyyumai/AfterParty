import Foundation

struct MockHealthDataService: HealthDataService {
    func fetchMetrics(from startDate: Date, to endDate: Date) async throws -> [HealthMetric] {
        let baseline = Baseline.mock
        let seed = Calendar.current.component(.day, from: startDate)
        let heartRateLift = Double(8 + (seed % 8))
        let hrvDrop = Double(7 + (seed % 9))
        let restingLift = Double(4 + (seed % 5))

        return [
            HealthMetric(kind: .heartRate, timestamp: endDate, value: baseline.value(for: .heartRate) + heartRateLift),
            HealthMetric(kind: .hrv, timestamp: endDate, value: max(30, baseline.value(for: .hrv) - hrvDrop)),
            HealthMetric(kind: .restingHeartRate, timestamp: endDate, value: baseline.value(for: .restingHeartRate) + restingLift)
        ]
    }

    func fetchBaseline(before date: Date) async throws -> Baseline {
        Baseline.mock
    }

    func fetchTimeline(for kind: HealthMetricKind, session: DrinkingSession) async throws -> [HealthMetric] {
        let calendar = Calendar.current
        let baseline = Baseline.mock.value(for: kind)
        let anchor = calendar.date(byAdding: .hour, value: -3, to: session.startDate) ?? session.startDate
        let points = 10

        return (0..<points).compactMap { index in
            guard let timestamp = calendar.date(byAdding: .hour, value: index, to: anchor) else {
                return nil
            }

            let progress = Double(index) / Double(points - 1)
            let wave = sin(progress * .pi)
            let value: Double

            switch kind {
            case .heartRate:
                value = baseline + (wave * 20) + Double(index % 2)
            case .hrv:
                value = baseline - (wave * 18) - Double(index % 3)
            case .restingHeartRate:
                value = baseline + (wave * 8) + Double(index % 2)
            }

            return HealthMetric(kind: kind, timestamp: timestamp, value: value)
        }
    }
}
