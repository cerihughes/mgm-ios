import Foundation

struct Event {
    let number: Int
    let date: Date?
    let playlist: Playlist?
    let classicAlbum: Album?
    let newAlbum: Album?
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
    let images: Images
}

struct Playlist {
    let spotifyID: String?
    let name: String
    let owner: String
    let images: Images
}

struct Images {
    let size64: String?
    let size300: String?
    let size640: String?

    func image(for size: Int) -> String? {
        if size > 300 {
            return size640 ?? size300 ?? size64
        }
        if size > 64 {
            return size300 ?? size640 ?? size64
        }
        return size64 ?? size300 ?? size640
    }
}
