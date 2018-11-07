import UIKit

private let spotifyLaunchPageIdentifier = "spotifyLaunchPageIdentifier"

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

    static func createSpotifyResourceLocator(spotifyURL: URL) -> ResourceLocator {
        return ResourceLocator(identifier: spotifyLaunchPageIdentifier, data: [spotifyURLKey : spotifyURL])
    }

    var spotifyURL: URL? {
        return data[ResourceLocator.spotifyURLKey] as? URL
    }
}
