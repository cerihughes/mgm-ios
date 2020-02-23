import Firebase
import Madog
import UIKit

private let twelveHours = 60.0 * 60.0 * 12.0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let madog = Madog<ResourceLocator>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(twelveHours)

        FirebaseApp.configure()

        let cache = URLCache(memoryCapacity: 16 * 1024 * 1024, diskCapacity: 128 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache

        let window = UIWindow()
        window.makeKeyAndVisible()
        self.window = window

        madog.resolve(resolver: MGMResolver())
        let initialRLs: [ResourceLocator] = [.latestEvent, .scores]
        let identifier = MultiUIIdentifier.createTabBarControllerIdentifier()
        return madog.renderUI(identifier: identifier, tokens: initialRLs, in: window) != nil
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        madog.resolve(resolver: MGMResolver())

        guard let dataRepository = serviceProvider?.dataRepository else {
            completionHandler(.failed)
            return
        }

        let previousEvents = dataRepository.localEvents
        _ = dataRepository.getEventData { response in
            switch response {
            case let .success(events):
                if events == previousEvents {
                    completionHandler(.noData)
                } else {
                    completionHandler(.newData)
                }
            case .failure:
                completionHandler(.failed)
            }
        }
    }

    private var serviceProvider: MGMServiceProvider? {
        return madog.serviceProviders[mgmServiceProviderName] as? MGMServiceProvider
    }
}
