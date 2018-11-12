import Foundation

struct Event {
    let number: Int
    let location: Location?
    let date: Date?
    let playlist: Playlist?
    let classicAlbum: Album?
    let newAlbum: Album?
}

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
}

enum AlbumType {
    case classic, new
}

struct Album {
    let type: AlbumType
    let spotifyID: String?
    let name: String
    let artist: String
    let score: Float?
    let images: [Image]
}

struct Playlist {
    let spotifyID: String?
    let name: String
    let owner: String
    let images: [Image]
}

struct Image {
    let size: Int?
    let url: String
}
