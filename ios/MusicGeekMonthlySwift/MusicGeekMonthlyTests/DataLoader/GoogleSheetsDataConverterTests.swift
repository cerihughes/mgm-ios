import XCTest

class GoogleSheetsDataConverterTests: XCTestCase {

    // MARK: CUT
    private var dataConverter: GoogleSheetsDataConverterImplementation!

    override func setUp() {
        super.setUp()

        self.dataConverter = GoogleSheetsDataConverterImplementation()
    }

    override func tearDown() {
        self.dataConverter = nil

        super.tearDown()
    }

    func testGoodData() {
        let events = runTestForSuccess(resource: "GoodData")
        XCTAssertEqual(events.count, 60)
        XCTAssertEqual(events.first!.number, 1)
        XCTAssertEqual(events.last!.number, 63)
    }

    // MARK: Private utilities

    private func runTestForSuccess(resource: String) -> [Event] {
        guard let events = createModel(resource: resource)?.asSuccessData() else {
            XCTFail("Expected events response")
            fatalError()
        }
        return events
    }

    private func createModel(resource: String) -> GoogleSheetsDataConverterResponse? {
        guard let data = loadData(forResource: resource, withExtension: "json") else {
            return nil
        }

        guard let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }

        return createModel(jsonString: jsonString)
    }

    private func createModel(jsonString: String) -> GoogleSheetsDataConverterResponse? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        return dataConverter.convert(data: data)
    }
}

extension GoogleSheetsDataConverterResponse {
    func asSuccessData() -> [Event]? {
        guard case .success(let events) = self else {
            return nil
        }
        return events
    }

    func asFailureData() -> Error? {
        guard case .failure(let error) = self else {
            return nil
        }
        return error
    }
}
