import UIKit

let spotifyLaunchPageIdentifier = "spotifyLaunchPageIdentifier"

class SpotifyLaunchPage: PageFactory, Page {

    // MARK: PageFactory

    static func createPage() -> Page {
        return SpotifyLaunchPage()
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
            let albumID = rl.spt_albumID,
            let spotifyURL = URL(string: "spotify:album:\(albumID)"),
            UIApplication.shared.canOpenURL(spotifyURL)
            else {
                return nil
        }

        UIApplication.shared.open(spotifyURL, options: [:], completionHandler: nil)

        return nil
    }
}

extension ResourceLocator {
    private static let spotifyAlbumIDKey = "spotifyAlbumID"

    static func createSpotifyResourceLocator(albumID: String) -> ResourceLocator {
        return ResourceLocator(identifier: spotifyLaunchPageIdentifier, data: [spotifyAlbumIDKey: albumID])
    }

    var spt_albumID: String? {
        return data[ResourceLocator.spotifyAlbumIDKey]
    }
}
