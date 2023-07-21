import Madog
import UIKit

class ScoresViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(
        token: Navigation,
        navigationContext: AnyForwardBackNavigationContext<Navigation>
    ) -> UIViewController? {
        guard
            token == .scores,
            let imageLoader = serviceProvider?.imageLoader,
            let dataRepository = serviceProvider?.dataRepository
        else {
            return nil
        }

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let viewController = ScoresViewController(navigationContext: navigationContext, viewModel: viewModel)
        viewController.tabBarItem.tag = 1
        viewController.tabBarItem.title = "Album Scores"
        viewController.tabBarItem.image = UIImage(named: "chart_line")

        return viewController
    }
}
