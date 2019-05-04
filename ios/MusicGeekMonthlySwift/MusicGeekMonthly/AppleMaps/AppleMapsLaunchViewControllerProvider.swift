import Madog
import MapKit
import UIKit

fileprivate let appleMapsIdentifier = "appleMapsIdentifier"

class AppleMapsLaunchViewControllerProvider: TypedViewControllerProvider {

    // MARK: TypedViewControllerProvider

    override func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard
            resourceLocator.identifier == appleMapsIdentifier,
            let appleMapsLocationName = resourceLocator.appleMapsLocationName,
            let appleMapsLatitude = resourceLocator.appleMapsLatitude,
            let appleMapsLongitude = resourceLocator.appleMapsLongitude
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
