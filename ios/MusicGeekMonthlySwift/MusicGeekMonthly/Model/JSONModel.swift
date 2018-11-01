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
    let classicArtist: JSONStringValue?
    let classicAlbum: JSONStringValue?
    let classicMBID: JSONStringValue?
    let classicScore: JSONStringValue?
    let classicSpotifyID: JSONStringValue?
    let newArtist: JSONStringValue?
    let newAlbum: JSONStringValue?
    let newMBID: JSONStringValue?
    let newScore: JSONStringValue?
    let newSpotifyID: JSONStringValue?

    private enum CodingKeys: String, CodingKey {
        case ID = "gsx$id"
        case date = "gsx$date"
        case playlist = "gsx$playlist"
        case classicArtist = "gsx$classicartist"
        case classicAlbum = "gsx$classicalbum"
        case classicMBID = "gsx$classicmbid"
        case classicScore = "gsx$classicscore"
        case classicSpotifyID = "gsx$classicspotifyid"
        case newArtist = "gsx$newartist"
        case newAlbum = "gsx$newalbum"
        case newMBID = "gsx$newmbid"
        case newScore = "gsx$newscore"
        case newSpotifyID = "gsx$newspotifyid"
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
