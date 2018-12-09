import Madog
import UIKit

fileprivate let spotifyLaunchPageIdentifier = "spotifyLaunchPageIdentifier"

class SpotifyLaunchPage: PageObject {
    private let externalAppLauncher: ExternalAppLauncher = UIApplication.shared

    private var uuid: UUID?

    // MARK: PageObject

    override func register(with registry: ViewControllerRegistry) {
        _ = registry.add(registryFunction: createViewController(token:context:))
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
            rl.identifier == spotifyLaunchPageIdentifier,
            let spotifyURL = rl.spotifyURL,
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
        return ResourceLocator(identifier: spotifyLaunchPageIdentifier, data: [spotifyURLKey : spotifyURL])
    }

    var spotifyURL: URL? {
        return data?[ResourceLocator.spotifyURLKey] as? URL
    }
}
