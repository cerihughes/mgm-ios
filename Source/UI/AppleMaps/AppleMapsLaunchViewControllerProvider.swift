import Madog
import MapKit
import UIKit

class AppleMapsLaunchViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(token: Navigation, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard
            case let .appleMaps(locationName, latitude, longitude) = token
        else {
            return nil
        }

        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = locationName
        mapItem.openInMaps(launchOptions: nil)

        return nil
    }
}
