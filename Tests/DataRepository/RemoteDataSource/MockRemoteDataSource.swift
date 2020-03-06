import Foundation
import MGMRemoteApiClient

@testable import MusicGeekMonthly

class MockRemoteDataSource: RemoteDataSource {
    var loadEventDataResponse: Result<[EventApiModel], Error> = .failure(NSError())

    func loadEventData(_ completion: @escaping (Result<[EventApiModel], Error>) -> Void) {
        let response = loadEventDataResponse
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
}
