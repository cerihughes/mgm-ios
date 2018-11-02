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
    let name: String
    let artist: String
    let score: Float?
    let images: Images
}

struct Images {
    let size64: String?
    let size300: String?
    let size640: String?

    func image(for size: Int) -> String? {
        if size > 640 {
            return size640 ?? size300 ?? size64
        }
        if size > 300 {
            return size300 ?? size640 ?? size64
        }
        return size64 ?? size300 ?? size640
    }
}
