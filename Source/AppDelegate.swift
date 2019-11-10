import Firebase
import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    let madog = Madog<ResourceLocator>()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let cache = URLCache(memoryCapacity: 16 * 1024 * 1024, diskCapacity: 128 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache

        window.makeKeyAndVisible()

        madog.resolve(resolver: MGMResolver())
        let initialRLs: [ResourceLocator] = [.latestEvent, .scores]
        let identifier = MultiUIIdentifier.createTabBarControllerIdentifier()
        return madog.renderUI(identifier: identifier, tokens: initialRLs, in: window) != nil
    }
}
