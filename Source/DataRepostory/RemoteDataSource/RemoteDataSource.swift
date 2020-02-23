import Foundation

protocol RemoteDataSource {
    func loadEventData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken?
}

private let urlSchemeString = "https"
private let urlHostString = "mgm-gcp.appspot.com"
private let urlPathString = "/mgm.json"

class RemoteDataSourceImplementation: RemoteDataSource {
    private let dataLoader: DataLoader

    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }

    func loadEventData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
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
