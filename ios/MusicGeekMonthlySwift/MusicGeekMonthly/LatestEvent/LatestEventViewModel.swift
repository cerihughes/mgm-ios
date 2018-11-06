import UIKit

/// Domain-specific errors for the LatestEventViewModel
///
/// - noEvent: There is no latest event
enum LatestEventViewModelError: Error {
    case noEvent(String)
}

protocol LatestEventViewModel {
    /// The title to display in the UI
    var title: String {get}

    /// Any error / info message that needs to be rendered.
    var message: String? {get}

    /// Loads data. The completion block will be fired when data is available.
    func loadData(_ completion: @escaping () -> Void)

    /// The number of albums to render
    var numberOfAlbums: Int {get}

    /// Returns ae event album view model for the given index
    ///
    /// - Parameter index: the index
    /// - Returns: the event album view model, or nil if no model exists with the given index
    func eventAlbumViewModel(at index: Int) -> LatestEventAlbumViewModel?
}

/// Default implementation of LatestEventViewModel
final class LatestEventViewModelImplementation: LatestEventViewModel {
    private static let dateFormatter = DateFormatter.mgm_latestEventDateFormatter()

    private let dataLoader: ViewModelDataLoader
    private let imageLoader: ImageLoader

    private var eventAlbumViewModels: [LatestEventAlbumViewModel] = []
    private var dataLoaderToken: DataLoaderToken? = nil

    var event: Event? = nil
    var message: String? = nil

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

    func loadData(_ completion: @escaping () -> Void) {
        if let dataLoaderToken = dataLoaderToken {
            dataLoaderToken.cancel()
        }

        dataLoaderToken = dataLoader.loadData() { [unowned self] (response) in
            DispatchQueue.main.async {
                self.dataLoaderToken = nil

                switch (response) {
                case .success(let events):
                    self.handleDataLoaderSuccess(events: events, completion)
                case .failure(let error):
                    self.handleDataLoaderFailure(error: error, completion)
                }
            }
        }
    }

    var numberOfAlbums: Int {
        return eventAlbumViewModels.count
    }

    func eventAlbumViewModel(at index: Int) -> LatestEventAlbumViewModel? {
        guard index < eventAlbumViewModels.count else {
            return nil
        }

        return eventAlbumViewModels[index]
    }

    // MARK: Private

    private func handleDataLoaderSuccess(events: [Event], _ completion: () -> Void) {
        // Remove events without albums, then apply descending sort by ID
        let sortedEvents = events.filter { $0.classicAlbum != nil && $0.newAlbum != nil && $0.playlist != nil }.sorted { $0.number > $1.number }

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

    private func handleDataLoaderFailure(error: Error, _ completion: () -> Void) {
        self.event = nil
        self.eventAlbumViewModels = []
        self.message = error.localizedDescription
        completion()
    }

    private func updateStateAndNotify(event: Event, classicAlbum: Album, newAlbum: Album, _ completion: () -> Void) {
        self.event = event
        eventAlbumViewModels.append(LatestEventAlbumViewModelImplementation(imageLoader: imageLoader, album: classicAlbum))
        eventAlbumViewModels.append(LatestEventAlbumViewModelImplementation(imageLoader: imageLoader, album: newAlbum))
        if let playlist = event.playlist {
            eventAlbumViewModels.append(LatestEventPlaylistViewModelImplementation(imageLoader: imageLoader, playlist: playlist))
        }
        self.message = nil
        completion()
    }
}
