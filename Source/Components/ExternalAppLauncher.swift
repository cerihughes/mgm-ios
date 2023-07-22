import UIKit

protocol ExternalAppLauncher {
    func canOpen(externalURL: URL) -> Bool
    func open(externalURL: URL)
}

extension UIApplication: ExternalAppLauncher {
    func canOpen(externalURL: URL) -> Bool {
        canOpenURL(externalURL)
    }

    func open(externalURL: URL) {
        open(externalURL, options: [:], completionHandler: nil)
    }
}
