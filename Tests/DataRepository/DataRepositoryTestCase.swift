import XCTest

class DataRepositoryTestCase: XCTestCase {
    var localStorage: MockLocalStorage!
    var remoteDataSource: MockRemoteDataSource!
    var localNotificationsManager: MockLocalNotificationsManager!
    var dataRepository: DataRepository!

    override func setUp() {
        super.setUp()

        localStorage = MockLocalStorage()
        let localDataSource = LocalDataSourceImplementation(localStorage: localStorage)
        remoteDataSource = MockRemoteDataSource()

        let eventUpdateManager = EventUpdateManagerImplementation()
        localNotificationsManager = MockLocalNotificationsManager()
        dataRepository = DataRepositoryImplementation(localDataSource: localDataSource,
                                                      remoteDataSource: remoteDataSource,
                                                      eventUpdateManager: eventUpdateManager,
                                                      localNotificationsManager: localNotificationsManager)
    }

    override func tearDown() {
        localStorage = nil
        remoteDataSource = nil
        localNotificationsManager = nil
        dataRepository = nil

        super.tearDown()
    }
}
