import Foundation

/// The ViewModelDataLoader is used to load JSON responses from the backend and convert
/// them to view-model-friendly data structures (via the GCPDataConverter)
protocol ViewModelDataLoader {
    /// Loads and converts the latest data
    /// Multiple requests can take place simultaneously - a request can be cancelled
    /// by invoking the cancel method on the returned DataLoaderToken.
    ///
    /// - Parameters:
    ///   - completion: the completion block
    /// - Returns: a data loader token than can be used to cancel the request.
    func loadData(_ completion: @escaping (GCPDataConverterResponse) -> Void) -> DataLoaderToken?
}

final class ViewModelDataLoaderImplementation: ViewModelDataLoader {
    private let dataLoader: GCPDataLoader
    private let dataConverter: GCPDataConverter

    init(dataLoader: GCPDataLoader, dataConverter: GCPDataConverter) {
        self.dataLoader = dataLoader
        self.dataConverter = dataConverter
    }

    func loadData(_ completion: @escaping (GCPDataConverterResponse) -> Void) -> DataLoaderToken? {
        return dataLoader.loadData { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case let .success(data):
                    self?.handleDataLoaderSuccess(data: data, completion)
                case let .failure(error):
                    self?.handleDataLoaderFailure(error: error, completion)
                }
            }
        }
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: @escaping (GCPDataConverterResponse) -> Void) {
        let response = dataConverter.convert(data: data)
        switch response {
        case let .success(data):
            completion(.success(data))
        case let .failure(error):
            handleDataLoaderFailure(error: error, completion)
        }
    }

    private func handleDataLoaderFailure(error: Error, _ completion: @escaping (GCPDataConverterResponse) -> Void) {
        completion(.failure(error))
    }
}
