import Foundation

struct JSONModel: Codable {
    let feed: JSONFeed?
}

struct JSONFeed: Codable {
    let entry: [JSONEntry]?
}

struct JSONEntry: Codable {
    let ID: JSONStringValue?
    let date: JSONStringValue?
    let playlist: JSONStringValue?
    let playlistImage: JSONStringValue?
    let classicArtist: JSONStringValue?
    let classicAlbum: JSONStringValue?
    let classicScore: JSONStringValue?
    let classicSpotifyID: JSONStringValue?
    let classicImage64: JSONStringValue?
    let classicImage300: JSONStringValue?
    let classicImage640: JSONStringValue?
    let newArtist: JSONStringValue?
    let newAlbum: JSONStringValue?
    let newScore: JSONStringValue?
    let newSpotifyID: JSONStringValue?
    let newImage64: JSONStringValue?
    let newImage300: JSONStringValue?
    let newImage640: JSONStringValue?

    private enum CodingKeys: String, CodingKey {
        case ID = "gsx$id"
        case date = "gsx$eventdate"
        case playlist = "gsx$playlist"
        case playlistImage = "gsx$playlistimage"
        case classicArtist = "gsx$classicartist"
        case classicAlbum = "gsx$classicalbum"
        case classicScore = "gsx$classicscore"
        case classicSpotifyID = "gsx$classicspotifyid"
        case classicImage64 = "gsx$classicimage64"
        case classicImage300 = "gsx$classicimage300"
        case classicImage640 = "gsx$classicimage640"
        case newArtist = "gsx$newartist"
        case newAlbum = "gsx$newalbum"
        case newScore = "gsx$newscore"
        case newSpotifyID = "gsx$newspotifyid"
        case newImage64 = "gsx$newimage64"
        case newImage300 = "gsx$newimage300"
        case newImage640 = "gsx$newimage640"
    }
}

struct JSONStringValue: Codable {
    let value: String?

    var processedValue: String? {
        if let value = value, value.count > 0 {
            return value
        }
        return nil
    }

    private enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
