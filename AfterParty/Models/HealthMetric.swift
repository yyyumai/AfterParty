import Foundation
import SwiftUI

enum HealthMetricKind: String, CaseIterable, Identifiable, Codable, Sendable {
    case heartRate
    case hrv
    case restingHeartRate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .heartRate: "Heart Rate"
        case .hrv: "HRV"
        case .restingHeartRate: "Resting HR"
        }
    }

    var fullTitle: String {
        switch self {
        case .heartRate: "Heart Rate"
        case .hrv: "Heart Rate Variability"
        case .restingHeartRate: "Resting Heart Rate"
        }
    }

    var unit: String {
        switch self {
        case .heartRate, .restingHeartRate: "bpm"
        case .hrv: "ms"
        }
    }

    var symbolName: String {
        switch self {
        case .heartRate: "heart.fill"
        case .hrv: "waveform.path.ecg"
        case .restingHeartRate: "bed.double.fill"
        }
    }

    var tint: Color {
        switch self {
        case .heartRate: .pink
        case .hrv: .mint
        case .restingHeartRate: .orange
        }
    }
}

struct HealthMetric: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var kind: HealthMetricKind
    var timestamp: Date
    var value: Double

    init(id: UUID = UUID(), kind: HealthMetricKind, timestamp: Date, value: Double) {
        self.id = id
        self.kind = kind
        self.timestamp = timestamp
        self.value = value
    }
}

struct MetricComparison: Identifiable, Hashable, Sendable {
    var id: HealthMetricKind { kind }
    var kind: HealthMetricKind
    var baselineValue: Double
    var sessionValue: Double

    var changePercent: Double {
        guard baselineValue != 0 else { return 0 }
        return ((sessionValue - baselineValue) / baselineValue) * 100
    }

    var formattedBaseline: String {
        "\(Int(round(baselineValue))) \(kind.unit)"
    }

    var formattedSession: String {
        "\(Int(round(sessionValue))) \(kind.unit)"
    }

    var formattedPercent: String {
        let sign = changePercent >= 0 ? "+" : ""
        return "\(sign)\(Int(round(changePercent)))%"
    }

    var directionSymbol: String {
        changePercent >= 0 ? "arrow.up" : "arrow.down"
    }
}
