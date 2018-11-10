import Foundation

/// All possible responses for GoogleSheetsDataConverter calls
///
/// - success: The data was successfully converted into a model
/// - failure: The data could not be converted
enum GoogleSheetsDataConverterResponse {
    case success([Event])
    case failure(Error)
}

/// The GoogleSheetsDataConverter takes Data (typically received from the DataLoader) and converts
/// it into a model
protocol GoogleSheetsDataConverter {
    /// Converts the given Data into a model
    ///
    /// - Parameter data: the data to convert
    /// - Returns: the converted data, or an error response
    func convert(data: Data) -> GoogleSheetsDataConverterResponse
}

fileprivate let spotifyAlbumImageURLFormat = "https://i.scdn.co/image/%@"
fileprivate let spotifyPlaylistImageURLFormat = "https://mosaic.scdn.co/%d/%@"

/// Default implementation of GoogleSheetsDataConverter
final class GoogleSheetsDataConverterImplementation: GoogleSheetsDataConverter {
    private static let dateFormatter = DateFormatter.mgm_modelDateFormatter()

    func convert(data: Data) -> GoogleSheetsDataConverterResponse {
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
            if let event = createEvent(from: entry) {
                events.append(event)
            }
        }

        return events
    }

    private func createEvent(from entry: JSONEntry) -> Event? {
        guard let number = Int(entry.ID?.processedValue ?? "") else {
            return nil
        }

        // Hardcode the location for now:
        let location = Location(name: "Crafty Devil's Cellar",
                                latitude: 51.48227690,
                                longitude: -3.20186570)

        let dateString = entry.date?.processedValue
        let date = GoogleSheetsDataConverterImplementation.dateFormatter.date(from: dateString ?? "")
        let playlist = createPlaylist(from: entry, number: number)
        let classicAlbum = createClassicAlbum(from: entry)
        let newAlbum = createNewAlbum(from: entry)
        return Event(number: number,
                     location: location,
                     date: date,
                     playlist: playlist,
                     classicAlbum: classicAlbum,
                     newAlbum: newAlbum)
    }

    private func createPlaylist(from entry: JSONEntry, number: Int) -> Playlist? {
        guard let spotifyID = entry.playlist?.processedValue else {
            return nil
        }

        let images = createPlaylistImages(from: entry)
        let name = String(format: "Music Geek Monthly %d", number)
        let owner = "Andrew Jones"
        return Playlist(spotifyID: spotifyID, name: name, owner: owner, images: images)
    }

    private func createPlaylistImages(from entry: JSONEntry) -> Images {
        let value = entry.playlistImage?.processedValue
        return Images(size64: createPlaylistImageURLString(value: value, size: 60),
                      size300: createPlaylistImageURLString(value: value, size: 300),
                      size640: createPlaylistImageURLString(value: value, size: 640))
    }

    private func createClassicAlbum(from entry: JSONEntry) -> Album? {
        guard
            let name = entry.classicAlbum?.processedValue,
            let artist = entry.classicArtist?.processedValue
            else {
                return nil
        }

        let score = Float(entry.classicScore?.processedValue ?? "")
        let spotifyID = entry.classicSpotifyID?.processedValue
        let images = createClassicImages(from: entry)

        return Album(type: .classic,
                     spotifyID: spotifyID,
                     name: name,
                     artist: artist,
                     score: score,
                     images: images)
    }

    private func createClassicImages(from entry: JSONEntry) -> Images {
        return Images(size64: createAlbumImageURLString(value: entry.classicImage64?.processedValue),
                      size300: createAlbumImageURLString(value: entry.classicImage300?.processedValue),
                      size640: createAlbumImageURLString(value: entry.classicImage640?.processedValue))
    }

    private func createNewAlbum(from entry: JSONEntry) -> Album? {
        guard
            let name = entry.newAlbum?.processedValue,
            let artist = entry.newArtist?.processedValue
            else {
                return nil
        }

        let score = Float(entry.newScore?.processedValue ?? "")
        let spotifyID = entry.newSpotifyID?.processedValue
        let images = createNewImages(from: entry)

        return Album(type: .new,
                     spotifyID: spotifyID,
                     name: name,
                     artist: artist,
                     score: score,
                     images: images)
    }

    private func createNewImages(from entry: JSONEntry) -> Images {
        return Images(size64: createAlbumImageURLString(value: entry.newImage64?.processedValue),
                      size300: createAlbumImageURLString(value: entry.newImage300?.processedValue),
                      size640: createAlbumImageURLString(value: entry.newImage640?.processedValue))
    }

    private func createAlbumImageURLString(value: String?) -> String? {
        guard let value = value else {
            return nil
        }
        if let url = URL(string: value), url.scheme != nil {
            // Already returned as a URL
            return value
        }
        return String(format: spotifyAlbumImageURLFormat, value)
    }

    private func createPlaylistImageURLString(value: String?, size: Int) -> String? {
        guard let value = value else {
            return nil
        }
        return String(format: spotifyPlaylistImageURLFormat, size, value)
    }
}
