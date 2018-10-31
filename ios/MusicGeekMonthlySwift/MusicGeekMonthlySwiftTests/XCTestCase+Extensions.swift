import XCTest

extension XCTestCase {

    func loadData(forResource: String, withExtension: String?) -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: forResource, withExtension: withExtension) else {
            return nil
        }

        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return data
    }
}
