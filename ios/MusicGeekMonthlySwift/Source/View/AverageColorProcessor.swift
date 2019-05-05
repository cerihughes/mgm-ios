import UIKit

protocol AverageColorProcessor {
    func calculateAverageColor(for image: UIImage) -> UIColor?
}

final class AverageColorProcessorImplementation: AverageColorProcessor {
    private let context = CIContext()

    func calculateAverageColor(for image: UIImage, _ completion: @escaping (UIColor?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let color = self?.calculateAverageColor(for: image)
            DispatchQueue.main.async {
                completion(color)
            }
        }
    }

    func calculateAverageColor(for image: UIImage) -> UIColor? {
        var bitmap = [UInt8](repeating: 0, count: 4)

        var ciImage = image.ciImage
        if ciImage == nil {
            guard let cgImage = image.cgImage else {
                return nil
            }
            ciImage = CIImage(cgImage: cgImage)
        }

        guard let inputImage = ciImage else {
            return nil
        }

        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!

        guard let outputImage = filter.outputImage else {
            return nil
        }

        let outputExtent = outputImage.extent
        guard outputExtent.size.width == 1 && outputExtent.size.height == 1 else {
            return nil
        }

        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())

        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
}
