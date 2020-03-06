import XCTest

@testable import MusicGeekMonthly

class DataRepositoryTestCase: XCTestCase {
    var localStorage: MockLocalStorage!
    var remoteDataSource: MockRemoteDataSource!
    var dataRepository: DataRepository!

    override func setUp() {
        super.setUp()

        localStorage = MockLocalStorage()
        let localDataSource = LocalDataSourceImplementation(localStorage: localStorage)
        remoteDataSource = MockRemoteDataSource()
        dataRepository = DataRepositoryImplementation(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
    }

    override func tearDown() {
        localStorage = nil
        remoteDataSource = nil
        dataRepository = nil

        super.tearDown()
    }
}
