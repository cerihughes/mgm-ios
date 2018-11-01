import Foundation

extension DateFormatter {
    convenience init(dateFormat: String, timeZoneIdentifier: String) {
        self.init()

        self.dateFormat = dateFormat
        self.timeZone = TimeZone(identifier: timeZoneIdentifier)
    }

    static func mgm_dateFormatter() -> DateFormatter {
        return DateFormatter(dateFormat: "dd/MM/yyyy", timeZoneIdentifier: "UTC")
    }
}
