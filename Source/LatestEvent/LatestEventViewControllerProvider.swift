import Madog
import UIKit

private let latestEventIdentifier = "latestEventIdentifier"

class LatestEventViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard resourceLocator.identifier == latestEventIdentifier,
            let imageLoader = serviceProvider?.imageLoader,
            let dataRepository = serviceProvider?.dataRepository else {
            return nil
        }

        let viewModel = LatestEventViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let viewController = LatestEventViewController(navigationContext: navigationContext, viewModel: viewModel)
        viewController.tabBarItem.tag = 0
        viewController.tabBarItem.title = "Latest Event"
        viewController.tabBarItem.image = UIImage(named: "calendar")

        return viewController
    }
}

extension ResourceLocator {
    static var latestEvent: ResourceLocator {
        return ResourceLocator(identifier: latestEventIdentifier, data: nil)
    }
}
