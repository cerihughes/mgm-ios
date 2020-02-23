import Foundation

/// The GCPDataLoader is used to load JSON responses from the GCP backend.
protocol GCPDataLoader {
    /// Loads the latest data
    /// Multiple requests can take place simultaneously - a request can be cancelled
    /// by invoking the cancel method on the returned DataLoaderToken.
    ///
    /// - Parameters:
    ///   - completion: the completion block
    /// - Returns: a data loader token than can be used to cancel the request.
    func loadData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken?
}

private let urlSchemeString = "https"
private let urlHostString = "mgm-gcp.appspot.com"
private let urlPathString = "/mgm.json"

/// Default implementation of GCPDataLoader
final class GCPDataLoaderImplementation: GCPDataLoader {
    private let dataLoader: DataLoader

    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }

    func loadData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
        guard let url = createURL() else {
            let response = DataLoaderResponse.failure(DataLoaderError.badQuery("Can't create request"))
            completion(response)
            return nil
        }

        return dataLoader.loadData(url: url, completion)
    }

    private func createURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = urlSchemeString
        urlComponents.host = urlHostString
        urlComponents.path = urlPathString
        return urlComponents.url
    }
}

class CachingGCPDataLoaderImplementation: GCPDataLoader {
    private let wrappedDataLoader: GCPDataLoader
    private let localStorage: LocalStorage

    init(wrappedDataLoader: GCPDataLoader, localStorage: LocalStorage) {
        self.wrappedDataLoader = wrappedDataLoader
        self.localStorage = localStorage
    }

    func loadData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
        return wrappedDataLoader.loadData { [weak self] response in
            switch response {
            case let .success(data):
                self?.handleDataLoaderSuccess(data: data, completion)
            case let .failure(error):
                self?.handleDataLoaderFailure(error: error, completion)
            }
        }
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: @escaping (DataLoaderResponse) -> Void) {
        localStorage.eventData = data
        completion(.success(data))
    }

    private func handleDataLoaderFailure(error: Error, _ completion: @escaping (DataLoaderResponse) -> Void) {
        if let data = localStorage.eventData {
            completion(.success(data))
            return
        }

        if let data = createFallbackData() {
            completion(.success(data))
            return
        }

        completion(.failure(error))
    }

    private func createFallbackData() -> Data? {
        let bundle = Bundle(for: CachingGCPDataLoaderImplementation.self)

        if let path = bundle.path(forResource: "gcp", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        return nil
    }
}
