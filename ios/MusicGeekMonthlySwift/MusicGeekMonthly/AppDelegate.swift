import Crashlytics
import Fabric
import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    let madog = Madog(resolver: RuntimeResolver())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        let cache = URLCache(memoryCapacity: 16 * 1024 * 1024, diskCapacity: 128 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache

        window.makeKeyAndVisible()

        let initialRLs = [ResourceLocator.latestEvent(), ResourceLocator.scores()]
        let identifier = MultiPageUIIdentifier.createTabBarControllerIdentifier()
        return madog.renderMultiPageUI(identifier, with: initialRLs, in: window)
    }
}

