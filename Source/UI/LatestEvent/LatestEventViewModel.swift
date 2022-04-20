import Foundation

/// Domain-specific errors for the LatestEventViewModel
///
/// - noEvent: There is no latest event
enum LatestEventViewModelError: Error {
    case noEvent(String)
}

typealias MapReference = (latitude: Double, longitude: Double)

protocol LatestEventViewModel: AlbumArtViewModel {
    /// The title to display in the UI
    var title: String { get }

    /// The location name
    var locationName: String? { get }

    /// The map reference
    var mapReference: MapReference? { get }

    /// Any error / info message that needs to be rendered.
    var message: String? { get }

    /// The title of the retry button (when visible)
    var retryButtonTitle: String { get }

    /// Loads data. The completion block will be fired when data is available.
    func loadData(_ completion: @escaping () -> Void)

    /// The number of entities (albums and playlists) to render
    var numberOfEntites: Int { get }

    /// Whether there's a locations available
    var isLocationAvailable: Bool { get }

    /// The title for the given section
    func headerTitle(for section: Int) -> String?

    /// Returns entity view data (album or playlist) for the given index
    ///
    /// - Parameter index: the index
    /// - Returns: the entity view model, or nil if no model exists with the given index
    func eventEntityViewData(at index: Int) -> LatestEventEntityViewData?
}

/// Default implementation of LatestEventViewModel
final class LatestEventViewModelImplementation: AlbumArtViewModelImplementation, LatestEventViewModel {
    private static let dateFormatter = DateFormatter.mgm_latestEventDateFormatter()

    private let dataRepository: DataRepository

    private var eventEntityViewModels: [LatestEventEntityViewData] = []

    let retryButtonTitle = "Retry"
    var event: Event?
    var message: String?

    init(dataRepository: DataRepository, imageLoader: ImageLoader) {
        self.dataRepository = dataRepository

        super.init(imageLoader: imageLoader)
    }

    var title: String {
        guard let date = event?.date else {
            return "Next Event"
        }
        let dateString = LatestEventViewModelImplementation.dateFormatter.string(from: date)
        return String(format: "Next Event: %@", dateString)
    }

    var locationName: String? {
        guard let location = event?.location else {
            return nil
        }
        return location.name
    }

    var mapReference: MapReference? {
        guard let location = event?.location else {
            return nil
        }
        return (latitude: location.latitude, longitude: location.longitude)
    }

    func loadData(_ completion: @escaping () -> Void) {
        dataRepository.getEventData { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case let .success(events):
                    self?.handleDataLoaderSuccess(events: events, completion)
                case let .failure(error):
                    self?.handleDataLoaderFailure(error: error, completion)
                }
            }
        }
    }

    var numberOfEntites: Int {
        return eventEntityViewModels.count
    }

    var isLocationAvailable: Bool {
        return event?.location != nil
    }

    func headerTitle(for section: Int) -> String? {
        switch section {
        case 0: return "LOCATION"
        case 1: return "LISTENING TO"
        default: return nil
        }
    }

    func eventEntityViewData(at index: Int) -> LatestEventEntityViewData? {
        guard index < eventEntityViewModels.count else {
            return nil
        }

        return eventEntityViewModels[index]
    }

    // MARK: Private

    private func handleDataLoaderSuccess(events: [Event], _ completion: () -> Void) {
        // Remove events without albums, then apply descending sort by ID
        let sortedEvents = events.filter { $0.classicAlbum != nil && $0.newAlbum != nil }.sorted { $0.number > $1.number }

        guard
            let event = sortedEvents.first,
            let classicAlbum = event.classicAlbum,
            let newAlbum = event.newAlbum
        else {
            let error = LatestEventViewModelError.noEvent("No events returned")
            handleDataLoaderFailure(error: error, completion)
            return
        }

        updateStateAndNotify(event: event, classicAlbum: classicAlbum, newAlbum: newAlbum, completion)
    }

    private func handleDataLoaderFailure(error _: Error, _ completion: () -> Void) {
        event = nil
        eventEntityViewModels = []
        message = .dataLoaderErrorMessage
        completion()
    }

    private func updateStateAndNotify(event: Event, classicAlbum: Album, newAlbum: Album, _ completion: () -> Void) {
        self.event = event
        eventEntityViewModels.append(classicAlbum.asLatestEventEntityViewData())
        eventEntityViewModels.append(newAlbum.asLatestEventEntityViewData())
        if let playlist = event.playlist {
            eventEntityViewModels.append(playlist.asLatestEventEntityViewData())
        }
        message = nil
        completion()
    }
}

extension Album {
    func asLatestEventEntityViewData() -> LatestEventEntityViewData {
        return LatestEventEntityViewDataImplementation(
            loadingImage: (-1).loadingImage,
            images: images,
            entityType: type == .classic ? "CLASSIC ALBUM" : type == .new ? "NEW ALBUM" : "ALBUM",
            entityName: name,
            entityOwner: artist,
            spotifyURL: .createSpotifyAlbumURL(albumID: spotifyId))
    }
}

extension Playlist {
    func asLatestEventEntityViewData() -> LatestEventEntityViewData {
        return LatestEventEntityViewDataImplementation(
            loadingImage: (-1).loadingImage,
            images: images,
            entityType: "PLAYLIST",
            entityName: name,
            entityOwner: owner,
            spotifyURL: .createSpotifyPlaylistURL(playlistID: spotifyId))
    }
}
