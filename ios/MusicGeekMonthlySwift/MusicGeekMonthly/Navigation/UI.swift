import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
///At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class UI: ForwardNavigationContext {
    private let registry = ViewControllerRegistry<ResourceLocator>()
    private let navigationController = UINavigationController()

    init(pageLoader: PageLoader) {
        registry.forwardNavigationContext = self

        let pageFactories = pageLoader.pageFactories()
        for pageFactory in pageFactories {
            let page = pageFactory.createPage()
            page.register(with: registry)
        }

        let initialViewController = registry.createInitialViewController()
        navigationController.pushViewController(initialViewController, animated: false)
    }

    var initialViewController: UIViewController {
        return navigationController
    }

    // MARK: ForwardNavigationContext

    func navigate<T>(with token: T, animated: Bool) -> Bool {
        if let rl = token as? ResourceLocator, let viewController = registry.createViewController(from: rl) {
            navigationController.pushViewController(viewController, animated: animated)
        }
        return false
    }

    func leave(viewController: UIViewController, animated: Bool) -> Bool {
        guard let topViewController = navigationController.topViewController else {
            return false
        }

        if topViewController == viewController {
            navigationController.popViewController(animated: animated)
            return true
        }

        return false
    }
}
