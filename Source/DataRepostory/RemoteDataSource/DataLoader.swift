import Foundation

/// All possible responses for DataLoader calls
///
/// - success: The data was successfully loaded (Data as a parameter)
/// - failure: The data couldn't be loaded (Error as a parameter)
typealias DataLoaderResponse = Result<Data, Error>

/// Domain-specific errors for the DataLoader
///
/// - badQuery: A URLRequest couldn't be created from the given data
/// - unexpectedResponse: The URLSession responded without a response or an error
enum DataLoaderError: Error {
    case badQuery(String)
    case unexpectedResponse(String)
}

/// The DataLoader is used to load JSON responses from a remote service.
protocol DataLoader {
    /// Loads data for a given url
    /// Multiple requests can take place simultaneously - a request can be cancelled
    /// by invoking the cancel method on the returned DataLoaderToken.
    ///
    /// - Parameters:
    ///   - url: the url to load data from
    ///   - completion: the completion block
    /// - Returns: a data loader token than can be used to cancel the request.
    func loadData(url: URL, _ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken?
}

/// A token returned from every DataLoader invocation. This can be used to cancel
/// an ongoing request.
protocol DataLoaderToken {
    /// Cancels the DataLoader request
    func cancel()
}

/// Default implementation of DataLoader
final class DataLoaderImplementation: DataLoader {
    private let urlSession: URLSession

    init() {
        urlSession = URLSession(configuration: .default)
    }

    func loadData(url: URL, _ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
        let urlRequest = URLRequest(url: url)
        let dataTask = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let response = self?.createDataLoaderResponse(data: data, response: response, error: error) {
                completion(response)
            }
        }

        dataTask.resume()

        return dataTask
    }

    private func createDataLoaderResponse(data: Data?, response _: URLResponse?, error: Error?) -> DataLoaderResponse? {
        if let data = data {
            return .success(data)
        }

        if let error = error {
            let systemError = error as NSError
            if systemError.domain == NSURLErrorDomain, systemError.code == NSURLErrorCancelled {
                // Ignore "errors" due to cancelled requests
                return nil
            }
            return .failure(error)
        }

        return .failure(DataLoaderError.unexpectedResponse("The URLSessionDataTask didn't return data or an error"))
    }
}

extension URLSessionDataTask: DataLoaderToken {}
