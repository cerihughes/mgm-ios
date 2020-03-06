import Foundation
import MGMRemoteApiClient

protocol RemoteDataSource {
    func loadEventData(_ completion: @escaping (Result<[EventApiModel], Error>) -> Void)
}

class RemoteDataSourceImplementation: RemoteDataSource {
    init(basePath: String) {
        MGMRemoteApiClientAPI.basePath = basePath
    }

    func loadEventData(_ completion: @escaping (Result<[EventApiModel], Error>) -> Void) {
        DefaultAPI.events(completion: completion)
    }
}
