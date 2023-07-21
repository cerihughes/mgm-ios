import Madog
import UIKit

class SpotifyLaunchViewControllerProvider: TypedViewControllerProvider {
    private let externalAppLauncher: ExternalAppLauncher = UIApplication.shared

    // MARK: TypedViewControllerProvider

    override func createViewController(
        token: Navigation,
        navigationContext: AnyForwardBackNavigationContext<Navigation>
    ) -> UIViewController? {
        guard case let .spotify(spotifyURL) = token, externalAppLauncher.canOpen(externalURL: spotifyURL) else {
            return nil
        }

        externalAppLauncher.open(externalURL: spotifyURL)
        return nil
    }
}
