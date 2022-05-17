import UIKit

protocol LatestEventEntityViewData: AlbumArtViewData {
    /// The album type / playlist
    var entityType: String { get }

    /// The album / playlist name
    var entityName: String { get }

    /// The artist name / playlist owner
    var entityOwner: String { get }

    /// The spotify URL to navigate to on interaction
    var spotifyURL: URL? { get }
}

struct LatestEventEntityViewDataImplementation: LatestEventEntityViewData {
    let loadingImage: UIImage?
    let images: [Image]?
    let entityType: String
    let entityName: String
    let entityOwner: String
    let spotifyURL: URL?
}
