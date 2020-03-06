import Foundation
import MGMRemoteApiClient

@testable import MusicGeekMonthly

extension EventApiModel {
    static func create(number: Int,
                       date: String? = nil,
                       location: LocationApiModel? = nil,
                       classicAlbum: AlbumApiModel? = nil,
                       newAlbum: AlbumApiModel? = nil,
                       playlist: PlaylistApiModel? = nil) -> EventApiModel {
        return EventApiModel(number: number, date: date, location: location, classicAlbum: classicAlbum, newAlbum: newAlbum, playlist: playlist)
    }

    static func create(number: Int, classicAlbumScore: Float, newAlbumScore: Float) -> EventApiModel {
        let classicAlbum = AlbumApiModel.create(type: .classic, score: classicAlbumScore)
        let newAlbum = AlbumApiModel.create(type: .new, score: newAlbumScore)
        return create(number: number, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    static func create(number: Int, classicAlbumName: String, newAlbumName: String, score: Float = 5.0) -> EventApiModel {
        let classicAlbum = AlbumApiModel.create(type: .classic, name: classicAlbumName, score: score)
        let newAlbum = AlbumApiModel.create(type: .new, name: newAlbumName, score: score)
        return create(number: number, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    static func create(number: Int, classicAlbumArtist: String, newAlbumArtist: String, score: Float = 5.0) -> EventApiModel {
        let classicAlbum = AlbumApiModel.create(type: .classic, artist: classicAlbumArtist, score: score)
        let newAlbum = AlbumApiModel.create(type: .new, artist: newAlbumArtist, score: score)
        return create(number: number, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }
}

extension LocationApiModel {
    static func create(name: String = "name",
                       latitude: Double,
                       longitude: Double) -> LocationApiModel {
        return LocationApiModel(name: name, latitude: latitude, longitude: longitude)
    }
}

extension AlbumApiModel {
    static func create(type: AlbumApiModel.ModelType,
                       spotifyId: String? = nil,
                       name: String = "name",
                       artist: String = "artist",
                       score: Float? = nil,
                       images: [ImageApiModel]? = nil) -> AlbumApiModel {
        return AlbumApiModel(type: type, spotifyId: spotifyId, name: name, artist: artist, score: score, images: images)
    }
}

extension PlaylistApiModel {
    static func create(spotifyId: String,
                       name: String = "name",
                       owner: String = "owner",
                       images: [ImageApiModel]? = nil) -> PlaylistApiModel {
        return PlaylistApiModel(spotifyId: spotifyId, name: name, owner: owner, images: images)
    }
}
