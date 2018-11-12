import UIKit

/// All possible responses for ImageLoader calls
///
/// - success: The image was successfully loaded (UIImage as a parameter)
/// - failure: The image couldn't be loaded (Error as a parameter)
enum ImageLoaderResponse {
    case success(UIImage)
    case failure(Error)
}

/// Domain-specific errors for the ImageLoader
///
/// - badImageData: The loaded data couldn't be converted into an image
enum ImageLoaderError: Error {
    case badImageData(String)
}

/// The ImageLoader is used to load images for the albums being viewed
protocol ImageLoader {
    /// Loads image data for the given URL.
    /// Multiple requests can take place simultaneously - a request can be cancelled
    /// by invoking the cancel method on the returned DataLoaderToken.
    ///
    /// - Parameters:
    ///   - url: the image URL
    ///   - completion: the completion block
    /// - Returns: a data loader token than can be used to cancel the request.
    func loadImage(url: URL, _ completion: @escaping (ImageLoaderResponse) -> Void) -> DataLoaderToken?
}

/// Default implementation of ImageLoader
final class ImageLoaderImplementation: ImageLoader {
    private let dataLoader: DataLoader

    init(dataLoader: DataLoader) {
        self.dataLoader = dataLoader
    }
    
    func loadImage(url: URL, _ completion: @escaping (ImageLoaderResponse) -> Void) -> DataLoaderToken? {
        return dataLoader.loadData(url: url) { [weak self] (response) in
            switch (response) {
            case .success(let data):
                self?.handleDataLoaderSuccess(data: data, completion)
            case .failure(let error):
                self?.handleDataLoaderFailure(error: error, completion)
            }
        }
    }

    // MARK: Private

    private func handleDataLoaderSuccess(data: Data, _ completion: @escaping (ImageLoaderResponse) -> Void) {
        guard let image = UIImage(data: data) else {
            handleDataLoaderFailure(error: ImageLoaderError.badImageData("The loaded data couldn't be converted into an image"), completion)
            return
        }
        completion(.success(image))
    }

    private func handleDataLoaderFailure(error: Error, _ completion: @escaping (ImageLoaderResponse) -> Void) {
        completion(.failure(error))
    }
}
