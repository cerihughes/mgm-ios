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
protocol ScoresViewModel: AlbumArtViewModel {
    /// The number of scores loaded by the last query
    var numberOfScores: Int { get }

    /// The display strings for the different types of albums
    var albumTypes: [String] { get }

    /// The index of the selected album type
    var selectedAlbumType: Int { get set }

    /// Whether the data has loaded successfully
    var dataLoaded: Bool { get }

    /// Any error / info message that needs to be rendered.
    var message: String? { get }

    /// The title of the retry button (when visible)
    var retryButtonTitle: String { get }

    /// The placeholder to show when no filter is used
    var filterPlaceholder: String { get }

    /// A filter to apply to results
    var filter: String? { get set }

    /// Loads data. The completion block will be fired when data is available.
    func loadData(_ completion: @escaping () -> Void)

    /// Returns score view data for the given index
    ///
    /// - Parameter index: the index
    /// - Returns: the score view model, or nil if no data exists with the given index
    func scoreViewData(at index: Int) -> ScoreViewData?
}

private let scoresSort: (Album, Album) -> Bool = {
    let score0 = $0.score ?? 0.0
    let score1 = $1.score ?? 0.0
    if score0 != score1 {
        return score0 > score1
    }

    let name0 = $0.name.lowercased()
    let name1 = $1.name.lowercased()
    if name0 != name1 {
        return name0 < name1
    }

    return $0.artist.lowercased() < $1.artist.lowercased()
}

/// Default implementation of ScoresViewModel
final class ScoresViewModelImplementation: AlbumArtViewModelImplementation, ScoresViewModel {
    private let dataRepository: DataRepository

    private var classicAlbums: [Album] = []
    private var newAlbums: [Album] = []
    private var allAlbums: [Album] = []
    private var scoreViewModels: [ScoreViewData] = []
    private var filteredScoreViewModels: [ScoreViewData] = []

    var selectedAlbumType = 2 {
        didSet {
            applyAlbumTypeFilter()
        }
    }

    var filter: String? {
        didSet {
            applyFilter()
        }
    }

    let albumTypes = ["Classic Albums", "New Albums", "All Albums"]
    let retryButtonTitle = "Retry"
    let filterPlaceholder = "Filter by album, artist or score"

    var message: String?
    init(dataRepository: DataRepository, imageLoader: ImageLoader) {
        self.dataRepository = dataRepository

        super.init(imageLoader: imageLoader)
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

    var dataLoaded: Bool {
        !scoreViewModels.isEmpty
    }

    var numberOfScores: Int {
        filteredScoreViewModels.count
    }

    func scoreViewData(at index: Int) -> ScoreViewData? {
        guard index < filteredScoreViewModels.count else {
            return nil
        }

        return filteredScoreViewModels[index]
    }

    // MARK: Private

    private func handleDataLoaderSuccess(events: [Event], _ completion: () -> Void) {
        guard !events.isEmpty else {
            let error = ScoresViewModelError.noEvents("No events returned")
            handleDataLoaderFailure(error: error, completion)
            return
        }
        updateStateAndNotify(events: events, completion)
    }

    private func handleDataLoaderFailure(error _: Error, _ completion: () -> Void) {
        scoreViewModels = []
        filteredScoreViewModels = []
        message = .dataLoaderErrorMessage
        completion()
    }

    private func updateStateAndNotify(events: [Event], _ completion: () -> Void) {
        // Categorise, remove scoreless albums and apply descending sort by score
        classicAlbums = events.compactMap(\.classicAlbum).filter { $0.score != nil }.sorted(by: scoresSort)
        newAlbums = events.compactMap(\.newAlbum).filter { $0.score != nil }.sorted(by: scoresSort)
        allAlbums = (classicAlbums + newAlbums).sorted(by: scoresSort)

        applyAlbumTypeFilter()
        completion()
    }

    private var filteredAlbums: [Album] {
        switch selectedAlbumType {
        case 0: return classicAlbums
        case 1: return newAlbums
        default: return allAlbums
        }
    }

    private func applyAlbumTypeFilter() {
        let positions = calculatePositions(for: filteredAlbums)
        scoreViewModels = filteredAlbums
            .enumerated()
            .map { ScoreViewDataImplementation(album: $0.element, index: $0.offset, position: positions[$0.offset]) }
        applyFilter()
    }

    private func calculatePositions(for albums: [Album]) -> [String] {
        let scores = albums.map { $0.score ?? 0.0 }
        var positions = [String]()
        var currentPosition = 0
        var currentValue: Float = 11.0
        for (index, value) in scores.enumerated() {
            if value != currentValue {
                currentValue = value
                currentPosition = index + 1
            }
            positions.append(String(currentPosition))
        }
        return positions
    }

    private func applyFilter() {
        guard
            let trimmed = filter?.trimmingCharacters(in: .whitespacesAndNewlines),
            !trimmed.isEmpty,
            !self.scoreViewModels.isEmpty
        else {
            filteredScoreViewModels = scoreViewModels
            message = nil
            return
        }

        filteredScoreViewModels = scoreViewModels
            .filter {
                $0.albumName.mgm_contains(filter: trimmed) || $0.artistName.mgm_contains(filter: trimmed) || $0.rating
                    .starts(with: trimmed)
            }
        message = filteredScoreViewModels.isEmpty ? "No results for filter: \(trimmed)" : nil
    }
}

extension String {
    func mgm_contains(filter: String) -> Bool {
        range(of: filter, options: .caseInsensitive) != nil
    }
}
