import Foundation

protocol LocalDataSource {
    var localStorage: LocalStorage { get }
}

class LocalDataSourceImplementation: LocalDataSource {
    let localStorage: LocalStorage

    init(localStorage: LocalStorage) {
        self.localStorage = localStorage

        if localStorage.eventData == nil {
            localStorage.eventData = createFallbackData()
        }
    }

    private func createFallbackData() -> Data? {
        let bundle = Bundle(for: LocalDataSourceImplementation.self)

        if let path = bundle.path(forResource: "gcp", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return data
        }
        return nil
    }
}
