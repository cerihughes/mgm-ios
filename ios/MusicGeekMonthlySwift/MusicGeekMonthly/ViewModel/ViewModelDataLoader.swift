import Foundation

/// The ViewModelDataLoader is used to load JSON responses from the Google Sheets backend and convert
/// them to view-model-friendly data structures (via the DataConverter)
protocol ViewModelDataLoader {
    /// Loads and converts the latest data
    /// Multiple requests can take place simultaneously - a request can be cancelled
    /// by invoking the cancel method on the returned DataLoaderToken.
    ///
    /// - Parameters:
    ///   - completion: the completion block
    /// - Returns: a data loader token than can be used to cancel the request.
    func loadData(_ completion: @escaping (DataConverterResponse) -> Void) -> DataLoaderToken?
}

final class ViewModelDataLoaderImplementation: ViewModelDataLoader {
    private let dataLoader: GoogleSheetsDataLoader
    private let dataConverter: DataConverter

    init(dataLoader: GoogleSheetsDataLoader, dataConverter: DataConverter) {
        self.dataLoader = dataLoader
        self.dataConverter = dataConverter
    }

    func loadData(_ completion: @escaping (DataConverterResponse) -> Void) -> DataLoaderToken? {
        return dataLoader.loadData() { [unowned self] (response) in
            DispatchQueue.main.async {
                switch (response) {
                case .success(let data):
                    self.handleDataLoaderSuccess(data: data, completion)
                case .failure(let error):
                    self.handleDataLoaderFailure(error: error, completion)
                }
            }
        }
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: @escaping (DataConverterResponse) -> Void) {
        let response = dataConverter.convert(data: data)
        switch (response) {
        case .success(let events):
            completion(.success(events))
        case .failure(let error):
            handleDataLoaderFailure(error: error, completion)
        }
    }

    private func handleDataLoaderFailure(error: Error, _ completion: @escaping (DataConverterResponse) -> Void) {
        completion(.failure(error))
    }
}
