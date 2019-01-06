import Madog
import UIKit

fileprivate let spotifyLaunchIdentifier = "spotifyLaunchIdentifier"

class SpotifyLaunchViewControllerProvider: TypedViewControllerProviderObject {
    private let externalAppLauncher: ExternalAppLauncher = UIApplication.shared

    // MARK: TypedViewControllerProviderObject

    override func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard
            resourceLocator.identifier == spotifyLaunchIdentifier,
            let spotifyURL = resourceLocator.spotifyURL,
            externalAppLauncher.canOpen(externalURL: spotifyURL)
            else {
                return nil
        }

        externalAppLauncher.open(externalURL: spotifyURL)

        return nil
    }
}

extension ResourceLocator {
    private static let spotifyURLKey = "spotifyURL"

    static func spotify(spotifyURL: URL) -> ResourceLocator {
        return ResourceLocator(identifier: spotifyLaunchIdentifier, data: [spotifyURLKey : spotifyURL])
    }

    var spotifyURL: URL? {
        return data?[ResourceLocator.spotifyURLKey] as? URL
    }
}
