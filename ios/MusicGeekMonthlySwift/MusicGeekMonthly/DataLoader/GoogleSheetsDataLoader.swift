import Foundation

/// The GoogleSheetsDataLoader is used to load JSON responses from the Google Sheets backend.
protocol GoogleSheetsDataLoader {
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
private let urlHostString = "spreadsheets.google.com"
private let urlPathString = "/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values"
private let altQueryKey = "alt"
private let altQueryValue = "json"

/// Default implementation of GoogleSheetsDataLoader
final class GoogleSheetsDataLoaderImplementation: GoogleSheetsDataLoader {
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
        urlComponents.queryItems = [URLQueryItem(name: altQueryKey, value: altQueryValue)]

        return urlComponents.url
    }
}

class CachingGoogleSheetsDataLoaderImplementation: GoogleSheetsDataLoader {
    private static let userDefaultsKey = "CachingGoogleSheetsDataLoaderImplementation_userDefaultsKey"

    private let wrappedDataLoader: GoogleSheetsDataLoader
    private let userDefaults: UserDefaults

    init(wrappedDataLoader: GoogleSheetsDataLoader, userDefaults: UserDefaults) {
        self.wrappedDataLoader = wrappedDataLoader
        self.userDefaults = userDefaults
    }

    func loadData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
        return wrappedDataLoader.loadData() { [weak self] (response) in
            switch response {
            case .success(let data):
                self?.handleDataLoaderSuccess(data: data, completion)
            case .failure(let error):
                self?.handleDataLoaderFailure(error: error, completion)
            }
        }
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: @escaping (DataLoaderResponse) -> Void) {
        writeUserDefaultsData(data)
        completion(.success(data))
    }

    private func handleDataLoaderFailure(error: Error, _ completion: @escaping (DataLoaderResponse) -> Void) {
        if let data = readUserDefaultsData() {
            completion(.success(data))
            return
        }

        if let data = createFallbackData() {
            completion(.success(data))
            return
        }

        completion(.failure(error))
    }

    private func readUserDefaultsData() -> Data? {
        return userDefaults.data(forKey: CachingGoogleSheetsDataLoaderImplementation.userDefaultsKey)
    }

    private func writeUserDefaultsData(_ data: Data) {
        userDefaults.set(data, forKey: CachingGoogleSheetsDataLoaderImplementation.userDefaultsKey)
    }

    private func createFallbackData() -> Data? {
        let bundle = Bundle(for: CachingGoogleSheetsDataLoaderImplementation.self)

        if let path = bundle.path(forResource: "googleSheets", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        return nil
    }
}
