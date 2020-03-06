import Foundation
import MGMRemoteApiClient

extension EventApiModel {
    func convert() -> Event {
        let dateFormatter = DateFormatter.mgm_modelDateFormatter()
        return Event(number: number,
                     location: location?.convert(),
                     date: dateFormatter.date(from: date ?? ""),
                     playlist: playlist?.convert(),
                     classicAlbum: classicAlbum?.convert(),
                     newAlbum: newAlbum?.convert())
    }
}

extension LocationApiModel {
    func convert() -> Location {
        return Location(name: name,
                        latitude: latitude,
                        longitude: longitude)
    }
}

extension AlbumApiModel.ModelType {
    func convert() -> AlbumType {
        switch self {
        case .classic:
            return .classic
        case .new:
            return .new
        }
    }
}

extension AlbumApiModel {
    func convert() -> Album {
        return Album(type: type.convert(),
                     spotifyId: spotifyId,
                     name: name,
                     artist: artist,
                     score: score,
                     images: images?.map { $0.convert() })
    }
}

extension PlaylistApiModel {
    func convert() -> Playlist {
        return Playlist(spotifyId: spotifyId,
                        name: name,
                        owner: owner,
                        images: images?.map { $0.convert() })
    }
}

extension ImageApiModel {
    func convert() -> Image {
        return Image(size: size, url: url)
    }
}
