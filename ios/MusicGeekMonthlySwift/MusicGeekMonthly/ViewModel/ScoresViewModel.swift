import Foundation

/// The ScoresViewModel is reponsible for all interactions with the scores UI for the
/// app. It takes care of loading model data and translating it into view-specific
/// representations.
protocol ScoresViewModel {
    /// The number of scores loaded by the last query
    var numberOfScores: Int {get}

    /// The title to display in the UI
    var title: String {get}

    /// Any error / info message that needs to be rendered.
    var message: String? {get}

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
    private let dataLoader: GoogleSheetsDataLoader
    private let dataConverter: DataConverter
    private let imageLoader: ImageLoader

    private var scoreViewModels: [ScoreViewModel] = []
    private var dataLoaderToken: DataLoaderToken? = nil

    let title = "Just Eat Restaurant Finder"
    var message: String? = nil

    init(dataLoader: GoogleSheetsDataLoader, dataConverter: DataConverter, imageLoader: ImageLoader) {
        self.dataLoader = dataLoader
        self.dataConverter = dataConverter
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
                case .success(let data):
                    self.handleDataLoaderSuccess(data: data, completion)
                case .failure(let error):
                    self.handleDataLoaderFailure(error: error, completion)
                }
            }
        }
    }

    var numberOfScores: Int {
        return scoreViewModels.count
    }

    func scoreViewModel(at index: Int) -> ScoreViewModel? {
        guard index < scoreViewModels.count else {
            return nil
        }

        return scoreViewModels[index]
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: () -> Void) {
        let response = dataConverter.convert(data: data)
        switch (response) {
        case .success(let events):
            let message = events.count == 0 ? "No events returned" : nil
            updateStateAndNotify(events: events, message: message, completion)
        case .failure(let error):
            handleDataLoaderFailure(error: error, completion)
        }
    }

    private func handleDataLoaderFailure(error: Error, _ completion: () -> Void) {
        updateStateAndNotify(events: [], message: error.localizedDescription, completion)
    }

    private func updateStateAndNotify(events: [Event], message: String?, _ completion: () -> Void) {
        var albums: [Album] = []
        for event in events {
            if let classicAlbum = event.classicAlbum {
                albums.append(classicAlbum)
            }
            if let newAlbum = event.newAlbum {
                albums.append(newAlbum)
            }
        }
        // Descending sort by score
        albums = albums.sorted { $0.score ?? 0.0 < $1.score ?? 0.0 }
        self.scoreViewModels = albums.map { ScoreViewModelImplementation(imageLoader: imageLoader, album: $0) }
        self.message = message
        completion()
    }
}
