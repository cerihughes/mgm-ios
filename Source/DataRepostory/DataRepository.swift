import Foundation

enum DataRepositoryResponse<T> {
    case success(T)
    case failure(Error)
}

protocol DataRepository {
    var localEvents: [Event]? { get }

    func getEventData(_ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) -> DataLoaderToken?
}

class DataRepositoryImplementation: DataRepository {
    private let localDataSource: LocalDataSource
    private let remoteDataSource: RemoteDataSource

    private let decoder = JSONDecoder.create()

    init(localDataSource: LocalDataSource, remoteDataSource: RemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    var localEvents: [Event]? {
        guard let data = localDataSource.localStorage.eventData else {
            return nil
        }

        return try? decoder.decode(eventsData: data)
    }

    func getEventData(_ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) -> DataLoaderToken? {
        return remoteDataSource.loadEventData { [weak self] response in
            switch response {
            case let .success(data):
                self?.handleDataLoaderSuccess(data: data, completion)
            case let .failure(error):
                self?.handleDataLoaderFailure(error: error, completion)
            }
        }
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) {
        localDataSource.localStorage.eventData = data
        do {
            let events = try decoder.decode(eventsData: data)
            completion(.success(events))
        } catch {
            completion(.failure(error))
        }
    }

    private func handleDataLoaderFailure(error: Error, _ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) {
        if let data = localDataSource.localStorage.eventData {
            do {
                let events = try decoder.decode(eventsData: data)
                completion(.success(events))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(error))
        }
    }
}

extension JSONDecoder {
    static func create() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.mgm_modelDateFormatter())
        return decoder
    }

    func decode(eventsData: Data) throws -> [Event] {
        return try decode([Event].self, from: eventsData)
    }
}

extension JSONEncoder {
    static func create() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.mgm_modelDateFormatter())
        return encoder
    }

    func encode(events: [Event]) throws -> Data {
        return try encode(events)
    }
}
