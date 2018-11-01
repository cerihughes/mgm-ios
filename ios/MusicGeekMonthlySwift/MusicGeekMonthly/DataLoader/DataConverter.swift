import Foundation

/// All possible responses for DataConverter calls
///
/// - success: The data was successfully converted into a model
/// - failure: The data could not be converted
enum DataConverterResponse {
    case success([Event])
    case failure(Error)
}

/// The DataConverter takes Data (typically received from the DataLoader) and converts
/// it into a model
protocol DataConverter {
    /// Converts the given Data into a model
    ///
    /// - Parameter data: the data to convert
    /// - Returns: the converted data, or an error response
    func convert(data: Data) -> DataConverterResponse
}

/// Default implementation of DataConverter
final class DataConverterImplementation: DataConverter {
    private let dateFormatter = DateFormatter.mgm_dateFormatter()

    func convert(data: Data) -> DataConverterResponse {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(JSONModel.self, from: data)
            let events = convert(model: model)
            let sorted = events.sorted { $0.number < $1.number }
            return .success(sorted)
        } catch let error {
            return .failure(error)
        }
    }

    private func convert(model: JSONModel) -> [Event] {
        var events: [Event] = []

        guard let entries = model.feed?.entry else {
            return events
        }

        for entry in entries {
            if let event = createEvent(for: entry) {
                events.append(event)
            }
        }

        return events
    }

    private func createEvent(for entry: JSONEntry) -> Event? {
        guard let number = Int(entry.ID?.processedValue ?? "") else {
            return nil
        }

        let dateString = entry.date?.processedValue
        let date = dateFormatter.date(from: dateString ?? "")
        let spotifyPlaylistID = entry.playlist?.processedValue
        let classicAlbum = createClassicAlbum(for: entry)
        let newAlbum = createNewAlbum(for: entry)
        return Event(number: number,
                     date: date,
                     spotifyPlaylistID: spotifyPlaylistID,
                     classicAlbum: classicAlbum,
                     newAlbum: newAlbum)
    }

    private func createClassicAlbum(for entry: JSONEntry) -> Album? {
        guard
            let MBID = entry.classicMBID?.processedValue,
            let name = entry.classicAlbum?.processedValue,
            let artist = entry.classicArtist?.processedValue
            else {
                return nil
        }

        let score = Float(entry.classicScore?.processedValue ?? "")
        let spotifyID = entry.classicSpotifyID?.processedValue

        return Album(spotifyID: spotifyID,
                     MBID: MBID,
                     name: name,
                     artist: artist,
                     score: score)
    }

    private func createNewAlbum(for entry: JSONEntry) -> Album? {
        guard
            let MBID = entry.newMBID?.processedValue,
            let name = entry.newAlbum?.processedValue,
            let artist = entry.newArtist?.processedValue
            else {
                return nil
        }

        let score = Float(entry.newScore?.processedValue ?? "")
        let spotifyID = entry.newSpotifyID?.processedValue

        return Album(spotifyID: spotifyID,
                     MBID: MBID,
                     name: name,
                     artist: artist,
                     score: score)
    }
}
