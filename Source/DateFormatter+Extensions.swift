import Foundation

extension DateFormatter {
    convenience init(dateFormat: String, timeZoneIdentifier: String) {
        self.init()

        self.dateFormat = dateFormat
        timeZone = TimeZone(identifier: timeZoneIdentifier)
    }

    static func mgm_modelDateFormatter() -> DateFormatter {
        DateFormatter(dateFormat: "dd/MM/yyyy", timeZoneIdentifier: "UTC")
    }

    static func mgm_latestEventDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
}
