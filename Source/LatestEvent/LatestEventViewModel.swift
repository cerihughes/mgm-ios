import Foundation

/// Domain-specific errors for the LatestEventViewModel
///
/// - noEvent: There is no latest event
enum LatestEventViewModelError: Error {
    case noEvent(String)
}

typealias MapReference = (latitude: Double, longitude: Double)

protocol LatestEventViewModel {
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

    /// Returns an entity view model (album or playlist) for the given index
    ///
    /// - Parameter index: the index
    /// - Returns: the entity view model, or nil if no model exists with the given index
    func eventEntityViewModel(at index: Int) -> LatestEventEntityViewModel?
}

/// Default implementation of LatestEventViewModel
final class LatestEventViewModelImplementation: LatestEventViewModel {
    private static let dateFormatter = DateFormatter.mgm_latestEventDateFormatter()

    private let dataLoader: ViewModelDataLoader
    private let imageLoader: ImageLoader

    private var eventEntityViewModels: [LatestEventEntityViewModel] = []
    private var dataLoaderToken: DataLoaderToken?

    let retryButtonTitle = "Retry"
    var event: Event?
    var message: String?

    init(dataLoader: ViewModelDataLoader, imageLoader: ImageLoader) {
        self.dataLoader = dataLoader
        self.imageLoader = imageLoader
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
        if let dataLoaderToken = dataLoaderToken {
            dataLoaderToken.cancel()
        }

        dataLoaderToken = dataLoader.loadData { [weak self] response in
            DispatchQueue.main.async {
                self?.dataLoaderToken = nil

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

    func eventEntityViewModel(at index: Int) -> LatestEventEntityViewModel? {
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
        message = dataLoaderErrorMessage
        completion()
    }

    private func updateStateAndNotify(event: Event, classicAlbum: Album, newAlbum: Album, _ completion: () -> Void) {
        self.event = event
        eventEntityViewModels.append(LatestEventEntityViewModelImplementation(imageLoader: imageLoader, album: classicAlbum))
        eventEntityViewModels.append(LatestEventEntityViewModelImplementation(imageLoader: imageLoader, album: newAlbum))
        if let playlist = event.playlist {
            eventEntityViewModels.append(LatestEventEntityViewModelImplementation(imageLoader: imageLoader, playlist: playlist))
        }
        message = nil
        completion()
    }
}
