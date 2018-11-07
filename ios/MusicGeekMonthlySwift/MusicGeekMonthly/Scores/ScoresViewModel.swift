import Foundation

/// Domain-specific errors for the ScoresViewModel
///
/// - noEvents: There are no events to render
enum ScoresViewModelError: Error {
    case noEvents(String)
}

/// The ScoresViewModel is reponsible for all interactions with the scores UI for the
/// app. It takes care of loading model data and translating it into view-specific
/// representations.
protocol ScoresViewModel {
    /// The number of scores loaded by the last query
    var numberOfScores: Int {get}

    /// The title to display in the UI
    var title: String {get}

    /// Whether the data has loaded successfully
    var dataLoaded: Bool {get}

    /// Any error / info message that needs to be rendered.
    var message: String? {get}

    /// The title of the retry button (when visible)
    var retryButtonTitle: String {get}

    /// The placeholder to show when no filter is used
    var filterPlaceholder: String {get}

    /// A filter to apply to results
    var filter: String? {get set}

    /// Loads data. The completion block will be fired when data is available.
    func loadData(_ completion: @escaping () -> Void)

    /// Returns a score view model for the given index
    ///
    /// - Parameter index: the index
    /// - Returns: the score view model, or nil if no model exists with the given index
    func scoreViewModel(at index: Int) -> ScoreViewModel?
}

/// Default implementation of ScoresViewModel
final class ScoresViewModelImplementation: ScoresViewModel {
    private let dataLoader: ViewModelDataLoader
    private let imageLoader: ImageLoader

    private var scoreViewModels: [ScoreViewModel] = []
    private var filteredScoreViewModels: [ScoreViewModel] = []
    private var dataLoaderToken: DataLoaderToken? = nil

    var filter: String? = nil {
        didSet {
            applyFilter()
        }
    }

    let title = "Album Scores"
    let retryButtonTitle = "Retry"
    var message: String? = nil
    let filterPlaceholder = "Filter by album, artist or score"

    init(dataLoader: ViewModelDataLoader, imageLoader: ImageLoader) {
        self.dataLoader = dataLoader
        self.imageLoader = imageLoader
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

    var dataLoaded: Bool {
        return scoreViewModels.count > 0
    }

    var numberOfScores: Int {
        return filteredScoreViewModels.count
    }

    func scoreViewModel(at index: Int) -> ScoreViewModel? {
        guard index < filteredScoreViewModels.count else {
            return nil
        }

        return filteredScoreViewModels[index]
    }

    // MARK: Private

    private func handleDataLoaderSuccess(events: [Event], _ completion: () -> Void) {
        guard events.count > 0 else {
            let error = ScoresViewModelError.noEvents("No events returned")
            handleDataLoaderFailure(error: error, completion)
            return
        }
        updateStateAndNotify(events: events, completion)
    }

    private func handleDataLoaderFailure(error: Error, _ completion: () -> Void) {
        self.scoreViewModels = []
        self.filteredScoreViewModels = []
        self.message = dataLoaderErrorMessage
        completion()
    }

    private func updateStateAndNotify(events: [Event], _ completion: () -> Void) {
        var albums: [Album] = []
        for event in events {
            if let classicAlbum = event.classicAlbum {
                albums.append(classicAlbum)
            }
            if let newAlbum = event.newAlbum {
                albums.append(newAlbum)
            }
        }

        // Remove scoreless albums, then apply descending sort by score
        albums = albums.filter { $0.score != nil }.sorted { $0.score ?? 0.0 > $1.score ?? 0.0 }
        self.scoreViewModels = albums.enumerated().map { ScoreViewModelImplementation(imageLoader: imageLoader, album: $0.element, index: $0.offset) }
        self.message = nil

        applyFilter()
        completion()
    }

    private func applyFilter() {
        guard
            let trimmed = filter?.trimmingCharacters(in: .whitespacesAndNewlines),
            trimmed.count > 0,
            self.scoreViewModels.count > 0
            else {
                self.filteredScoreViewModels = self.scoreViewModels
                self.message = nil
                return
        }

        self.filteredScoreViewModels = self.scoreViewModels.filter { $0.albumName.mgm_contains(filter: trimmed) || $0.artistName.mgm_contains(filter: trimmed) || $0.rating.starts(with: trimmed) }
        self.message = self.filteredScoreViewModels.count == 0 ? "No results for filter: \(trimmed)" : nil
    }
}

extension String {
    func mgm_contains(filter: String) -> Bool {
        return self.range(of: filter, options: .caseInsensitive) != nil
    }
}
