import MGMRemoteApiClient
import XCTest

@testable import MusicGeekMonthly

class DataRepositoryTests: DataRepositoryTestCase {
    func testGoodData() {
        let events = runTestForSuccess(resource: "GoodData")
        XCTAssertEqual(events.count, 59)
        XCTAssertEqual(events.first!.number, 2)
        XCTAssertEqual(events.last!.number, 64)
    }

    func testGoodData_generatedAllObjects() {
        let event = runTestForSuccess(resource: "GoodData").last!
        XCTAssertNotNil(event.classicAlbum)
        XCTAssertNotNil(event.newAlbum)
        XCTAssertNotNil(event.playlist)
    }

    func testGoodData_generatedAllSpotifyIds() {
        let event = runTestForSuccess(resource: "GoodData").last!
        XCTAssertNotNil(event.classicAlbum!.spotifyId)
        XCTAssertNotNil(event.newAlbum!.spotifyId)
        XCTAssertNotNil(event.playlist!.spotifyId)
    }

    // MARK: Private utilities

    private func runTestForSuccess(resource: String) -> [Event] {
        remoteDataSource.loadEventDataResponse = createDataLoaderResponse(resource: resource)

        var events: [Event]?

        let testExpectation = expectation(description: "Remote Data Fetch")
        _ = dataRepository.getEventData { response in
            events = response.asSuccessData()
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        return events!
    }

    private func createDataLoaderResponse(resource: String) -> Result<[EventApiModel], Error> {
        guard let data = loadData(forResource: resource, withExtension: "json"),
            let events = try? JSONDecoder.create().decode(eventsData: data)
        else {
            XCTFail("Cannot load test data from \(resource)")
            return .failure(NSError())
        }

        return .success(events)
    }
}

extension DataRepositoryResponse {
    func asSuccessData() -> Success? {
        guard case let .success(events) = self else {
            return nil
        }
        return events
    }

    func asFailureData() -> Error? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }
}
