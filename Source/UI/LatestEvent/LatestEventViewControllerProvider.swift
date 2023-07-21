import Madog
import UIKit

class LatestEventViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(token: Navigation, navigationContext: AnyForwardBackNavigationContext<Navigation>) -> UIViewController? {
        guard
            token == .latestEvent,
            let imageLoader = serviceProvider?.imageLoader,
            let dataRepository = serviceProvider?.dataRepository
        else {
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
