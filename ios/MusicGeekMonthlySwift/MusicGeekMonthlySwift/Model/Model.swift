import Foundation

struct Event {
    let number: Int
    let date: Date?
    let spotifyPlaylistID: String?
    let classicAlbum: Album?
    let newAlbum: Album?
}

struct Album {
    let spotifyID: String?
    let MBID: String
    let name: String
    let artist: String
    let score: Float?
}
