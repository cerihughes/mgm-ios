import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class NavigationUI: ForwardNavigationContext {
    private let registry = ViewControllerRegistry<ResourceLocator>()
    private let tabBarController = UITabBarController()

    init(pageLoader: PageLoader) {
        registry.forwardNavigationContext = self

        let pageFactories = pageLoader.pageFactories()
        for pageFactory in pageFactories {
            let page = pageFactory.createPage()
            page.register(with: registry)
        }

        let initialViewControllers = registry.createInitialViewControllers()
        // For now, sort by reverse alphabetic order (so that "Latest Event" comes 1st - improve this when we need to...
        let sortedViewControllers = initialViewControllers.sorted { $0.tabBarItem.title ?? "" > $1.tabBarItem.title ?? "" }
        let navigationControllers = sortedViewControllers.map { UINavigationController(rootViewController: $0) }
        tabBarController.viewControllers = navigationControllers
    }

    var initialViewController: UIViewController {
        return tabBarController
    }

    // MARK: ForwardNavigationContext

    func navigate<T>(with token: T, from fromViewController: UIViewController, animated: Bool) -> Bool {
        if let rl = token as? ResourceLocator,
            let toViewController = registry.createViewController(from: rl),
            let navigationController = fromViewController.navigationController {
            navigationController.pushViewController(toViewController, animated: animated)
        }
        return false
    }
}
