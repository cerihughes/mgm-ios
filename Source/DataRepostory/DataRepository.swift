import Foundation
import MGMRemoteApiClient

typealias DataRepositoryResponse<T> = Result<T, Error>

protocol DataRepository {
    var localEvents: [Event]? { get }

    func getEventData(_ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void)
}

class DataRepositoryImplementation: DataRepository {
    private let localDataSource: LocalDataSource
    private let remoteDataSource: RemoteDataSource
    private let eventUpdateManager: EventUpdateManager
    private let localNotificationsManager: LocalNotificationsManager

    private let encoder = JSONEncoder.create()
    private let decoder = JSONDecoder.create()

    init(localDataSource: LocalDataSource,
         remoteDataSource: RemoteDataSource,
         eventUpdateManager: EventUpdateManager,
         localNotificationsManager: LocalNotificationsManager) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.eventUpdateManager = eventUpdateManager
        self.localNotificationsManager = localNotificationsManager
    }

    var localEvents: [Event]? {
        guard let data = localDataSource.localStorage.eventData else {
            return nil
        }

        return try? decoder.decode(eventsData: data)
            .map { $0.convert() }
    }

    func getEventData(_ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) {
        return remoteDataSource.loadEventData { [weak self] response in
            switch response {
            case let .success(events):
                self?.handleRemoteSuccess(events: events, completion)
            case let .failure(error):
                self?.handleRemoteFailure(error: error, completion)
            }
        }
    }

    // MARK: Private

    private func handleRemoteSuccess(events: [EventApiModel], _ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) {
        let oldEventApiModels = existingEventApiModels ?? []

        if let data = try? encoder.encode(events: events) {
            localDataSource.localStorage.eventData = data
        }

        let oldEvents = oldEventApiModels.map { $0.convert() }
        let newEvents = events.map { $0.convert() }

        let eventUpdates = eventUpdateManager.processEventUpdate(oldEvents: oldEvents, newEvents: newEvents)
        localNotificationsManager.scheduleLocalNotifications(eventUpdates: eventUpdates)

        completion(.success(newEvents))
    }

    private func handleRemoteFailure(error: Error, _ completion: @escaping (DataRepositoryResponse<[Event]>) -> Void) {
        if let data = localDataSource.localStorage.eventData {
            do {
                let events = try decoder.decode(eventsData: data)
                let mapped = events.map { $0.convert() }
                completion(.success(mapped))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(error))
        }
    }

    private var existingEventApiModels: [EventApiModel]? {
        guard let existingData = localDataSource.localStorage.eventData else {
            return nil
        }

        return try? decoder.decode(eventsData: existingData)
    }
}

extension JSONDecoder {
    static func create() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.mgm_modelDateFormatter())
        return decoder
    }

    func decode(eventsData: Data) throws -> [EventApiModel] {
        return try decode([EventApiModel].self, from: eventsData)
    }
}

extension JSONEncoder {
    static func create() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.mgm_modelDateFormatter())
        return encoder
    }

    func encode(events: [EventApiModel]) throws -> Data {
        return try encode(events)
    }
}
