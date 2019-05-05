import Foundation

/// All possible responses for GCPDataConverter calls
///
/// - success: The data was successfully converted into a model
/// - failure: The data could not be converted
enum GCPDataConverterResponse {
    case success([Event])
    case failure(Error)
}

/// The GCPDataConverter takes Data (typically received from the DataLoader) and converts
/// it into a model
protocol GCPDataConverter {
    /// Converts the given Data into a model
    ///
    /// - Parameter data: the data to convert
    /// - Returns: the converted data, or an error response
    func convert(data: Data) -> GCPDataConverterResponse
}

/// Default implementation of GCPDataConverter
final class GCPDataConverterImplementation: GCPDataConverter {
    private static let dateFormatter = DateFormatter.mgm_modelDateFormatter()

    func convert(data: Data) -> GCPDataConverterResponse {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.mgm_modelDateFormatter())
            let events = try decoder.decode([Event].self, from: data)
            return .success(events)
        } catch let error {
            return .failure(error)
        }
    }
}
