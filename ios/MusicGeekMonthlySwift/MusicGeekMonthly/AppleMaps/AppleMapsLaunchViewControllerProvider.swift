import Madog
import MapKit
import UIKit

fileprivate let appleMapsIdentifier = "appleMapsIdentifier"

class AppleMapsLaunchViewControllerProvider: ViewControllerProviderObject {
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard
            let rl = token as? ResourceLocator,
            rl.identifier == appleMapsIdentifier,
            let appleMapsLocationName = rl.appleMapsLocationName,
            let appleMapsLatitude = rl.appleMapsLatitude,
            let appleMapsLongitude = rl.appleMapsLongitude
            else {
                return nil
        }

        let coordinate = CLLocationCoordinate2DMake(appleMapsLatitude, appleMapsLongitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = appleMapsLocationName
        mapItem.openInMaps(launchOptions: nil)

        return nil
    }
}

extension ResourceLocator {
    private static let appleMapsLocationNameKey = "appleMapsLocationName"
    private static let appleMapsLatitudeKey = "appleMapsLatitude"
    private static let appleMapsLongitudeKey = "appleMapsLongitude"

    static func appleMaps(locationName: String, latitude: Double, longitude: Double) -> ResourceLocator {
        return ResourceLocator(identifier: appleMapsIdentifier,
                               data: [appleMapsLocationNameKey : locationName,
                                      appleMapsLatitudeKey : latitude,
                                      appleMapsLongitudeKey: longitude])
    }

    var appleMapsLocationName: String? {
        return data?[ResourceLocator.appleMapsLocationNameKey] as? String
    }

    var appleMapsLatitude: Double? {
        return data?[ResourceLocator.appleMapsLatitudeKey] as? Double
    }

    var appleMapsLongitude: Double? {
        return data?[ResourceLocator.appleMapsLongitudeKey] as? Double
    }
}
