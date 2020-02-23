import Foundation

class MockViewModelDataLoader: ViewModelDataLoader {
    var response: GCPDataConverterResponse = .failure(NSError())
    func loadData(_ completion: @escaping (GCPDataConverterResponse) -> Void) -> DataLoaderToken? {
        let response = self.response
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
        return MockDataLoaderToken()
    }
}
