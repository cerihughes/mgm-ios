import XCTest

class GCPDataConverterTests: XCTestCase {
    // MARK: CUT

    private var dataConverter: GCPDataConverterImplementation!

    override func setUp() {
        super.setUp()

        dataConverter = GCPDataConverterImplementation()
    }

    override func tearDown() {
        dataConverter = nil

        super.tearDown()
    }

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
        guard let events = createModel(resource: resource)?.asSuccessData() else {
            XCTFail("Expected events response")
            fatalError()
        }
        return events
    }

    private func createModel(resource: String) -> GCPDataConverterResponse? {
        guard let data = loadData(forResource: resource, withExtension: "json") else {
            return nil
        }

        guard let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }

        return createModel(jsonString: jsonString)
    }

    private func createModel(jsonString: String) -> GCPDataConverterResponse? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        return dataConverter.convert(data: data)
    }
}

extension GCPDataConverterResponse {
    func asSuccessData() -> [Event]? {
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
