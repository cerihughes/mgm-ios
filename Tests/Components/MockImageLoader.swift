import Foundation

@testable import MusicGeekMonthly

class MockImageLoader: ImageLoader {
    var response = ImageLoaderResponse.failure(NSError())
    func loadImage(url _: URL, _ completion: @escaping (ImageLoaderResponse) -> Void) -> DataLoaderToken? {
        let response = response
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
        return MockDataLoaderToken()
    }
}
