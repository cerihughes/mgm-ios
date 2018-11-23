import Crashlytics
import Fabric
import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let ui = TabBarNavigationUI<ResourceLocator>(pageResolver: RuntimePageResolver()) else {
            return false
        }

        Fabric.with([Crashlytics.self])

        let cache = URLCache(memoryCapacity: 16 * 1024 * 1024, diskCapacity: 128 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache

        window.rootViewController = ui.initialViewController
        window.makeKeyAndVisible()

        return true
    }
}
