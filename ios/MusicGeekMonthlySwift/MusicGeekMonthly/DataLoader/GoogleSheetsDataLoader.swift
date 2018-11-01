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

//https://spreadsheets.google.com/feeds/list/1SytsfXWjxomYL10F7y9V7LawxNPSfnLTXGZYE5F0nh0/od6/public/values?alt=json

/// Default implementation of FixerIODataLoader
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
