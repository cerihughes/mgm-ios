import UIKit

let spotifyLaunchPageIdentifier = "spotifyLaunchPageIdentifier"

class SpotifyLaunchPage: PageFactory, Page {
    private let externalAppLauncher: ExternalAppLauncher

    init(externalAppLauncher: ExternalAppLauncher) {
        self.externalAppLauncher = externalAppLauncher
    }

    // MARK: PageFactory

    static func createPage() -> Page {
        return SpotifyLaunchPage(externalAppLauncher: UIApplication.shared)
    }

    // MARK: Page

    func register<T>(with registry: ViewControllerRegistry<T>) {
        _ = registry.add(registryFunction: createViewController(token:context:))
    }

    // MARK: Private

    private func createViewController<T>(token: T, context: ForwardNavigationContext) -> UIViewController? {
        guard
            let rl = token as? ResourceLocator,
            rl.identifier == spotifyLaunchPageIdentifier,
            let spotifyURLString = rl.spotifyURLString,
            let spotifyURL = URL(string: spotifyURLString),
            externalAppLauncher.canOpen(externalURL: spotifyURL)
            else {
                return nil
        }

        externalAppLauncher.open(externalURL: spotifyURL)

        return nil
    }
}

extension ResourceLocator {
    private static let spotifyURLStringKey = "spotifyURLString"

    static func createSpotifyResourceLocator(spotifyURLString: String) -> ResourceLocator {
        return ResourceLocator(identifier: spotifyLaunchPageIdentifier, data: [spotifyURLStringKey: spotifyURLString])
    }

    var spotifyURLString: String? {
        return data[ResourceLocator.spotifyURLStringKey]
    }
}
