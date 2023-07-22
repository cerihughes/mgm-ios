import Foundation

struct Event: Equatable {
    let number: Int
    let location: Location?
    let date: Date?
    let playlist: Playlist?
    let classicAlbum: Album?
    let newAlbum: Album?
}

struct Location: Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
}

enum AlbumType: String {
    case classic, new
}

struct Album: Equatable {
    let eventNumber: Int
    let type: AlbumType
    let spotifyId: String?
    let name: String
    let artist: String
    let score: Float?
    let images: [Image]?
}

struct Playlist: Equatable {
    let spotifyId: String
    let name: String
    let owner: String
    let images: [Image]?
}

struct Image: Equatable {
    let size: Int?
    let url: String
}

extension Album {
    var uniqueID: String {
        "\(eventNumber)_\(type)"
    }
}
