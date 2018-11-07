import MapKit
import UIKit

private let appleMapsLaunchPageIdentifier = "appleMapsLaunchPageIdentifier"

class AppleMapsLaunchPage: PageFactory, Page {

    // MARK: PageFactory

    static func createPage() -> Page {
        return AppleMapsLaunchPage()
    }

    // MARK: Page

    func register<T>(with registry: ViewControllerRegistry<T>) {
        _ = registry.add(registryFunction: createViewController(token:context:))
    }

    // MARK: Private

    private func createViewController<T>(token: T, context: ForwardNavigationContext) -> UIViewController? {
        guard
            let rl = token as? ResourceLocator,
            rl.identifier == appleMapsLaunchPageIdentifier,
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

    static func createAppleMapsResourceLocator(appleMapsLocationName: String, appleMapsLatitude: Double, appleMapsLongitude: Double) -> ResourceLocator {
        return ResourceLocator(identifier: appleMapsLaunchPageIdentifier,
                               data: [appleMapsLocationNameKey : appleMapsLocationName,
                                      appleMapsLatitudeKey : appleMapsLatitude,
                                      appleMapsLongitudeKey: appleMapsLongitude])
    }

    var appleMapsLocationName: String? {
        return data[ResourceLocator.appleMapsLocationNameKey] as? String
    }

    var appleMapsLatitude: Double? {
        return data[ResourceLocator.appleMapsLatitudeKey] as? Double
    }

    var appleMapsLongitude: Double? {
        return data[ResourceLocator.appleMapsLongitudeKey] as? Double
    }
}
