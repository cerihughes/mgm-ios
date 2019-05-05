import Foundation

struct Event: Codable {
    let number: Int
    let location: Location?
    let date: Date?
    let playlist: Playlist?
    let classicAlbum: Album?
    let newAlbum: Album?
}

struct Location: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

enum AlbumType: String, Codable {
    case classic, new
}

struct Album: Codable {
    let type: AlbumType?
    let spotifyId: String?
    let name: String
    let artist: String
    let score: Float?
    let images: [Image]
}

struct Playlist: Codable {
    let spotifyId: String?
    let name: String
    let owner: String
    let images: [Image]
}

struct Image: Codable {
    let size: Int?
    let url: String
}
