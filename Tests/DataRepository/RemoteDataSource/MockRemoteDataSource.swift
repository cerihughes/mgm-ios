import Foundation

@testable import MusicGeekMonthly

class MockRemoteDataSource: RemoteDataSource {
    var loadEventDataResponse = DataLoaderResponse.failure(NSError())

    func loadEventData(_ completion: @escaping (DataLoaderResponse) -> Void) -> DataLoaderToken? {
        let response = loadEventDataResponse
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
        return MockDataLoaderToken()
    }
}
