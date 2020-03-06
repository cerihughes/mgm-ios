import Foundation

@testable import MusicGeekMonthly

extension Event {
    static func create(number: Int,
                       location: Location? = nil,
                       date: Date? = nil,
                       playlist: Playlist? = nil,
                       classicAlbum: Album? = nil,
                       newAlbum: Album? = nil) -> Event {
        return Event(number: number, location: location, date: date, playlist: playlist, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    static func create(number: Int, classicAlbumScore: Float, newAlbumScore: Float) -> Event {
        let classicAlbum = Album.create(type: .classic, score: classicAlbumScore)
        let newAlbum = Album.create(type: .new, score: newAlbumScore)
        return create(number: number, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    static func create(number: Int, classicAlbumName: String, newAlbumName: String, score: Float = 5.0) -> Event {
        let classicAlbum = Album.create(type: .classic, name: classicAlbumName, score: score)
        let newAlbum = Album.create(type: .new, name: newAlbumName, score: score)
        return create(number: number, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    static func create(number: Int, classicAlbumArtist: String, newAlbumArtist: String, score: Float = 5.0) -> Event {
        let classicAlbum = Album.create(type: .classic, artist: classicAlbumArtist, score: score)
        let newAlbum = Album.create(type: .new, artist: newAlbumArtist, score: score)
        return create(number: number, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    static func create(number: Int, classicAlbum: Album, newAlbum: Album) -> Event {
        return Event(number: number, location: nil, date: nil, playlist: nil, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }
}

extension Location {
    static func create(name: String = "name",
                       latitude: Double,
                       longitude: Double) -> Location {
        return Location(name: name, latitude: latitude, longitude: longitude)
    }
}

extension Album {
    static func create(type: AlbumType? = nil,
                       spotifyId: String? = nil,
                       name: String = "name",
                       artist: String = "artist",
                       score: Float? = nil,
                       images: [Image] = []) -> Album {
        return Album(type: type, spotifyId: spotifyId, name: name, artist: artist, score: score, images: images)
    }
}

extension Playlist {
    static func create(spotifyId: String? = nil,
                       name: String = "name",
                       owner: String = "owner",
                       images: [Image] = []) -> Playlist {
        return Playlist(spotifyId: spotifyId, name: name, owner: owner, images: images)
    }
}
