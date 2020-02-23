import Madog
import UIKit

private let scoresIdentifier = "scoresIdentifier"

class ScoresViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard resourceLocator.identifier == scoresIdentifier,
            let imageLoader = serviceProvider?.imageLoader,
            let dataRepository = serviceProvider?.dataRepository else {
            return nil
        }

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let viewController = ScoresViewController(navigationContext: navigationContext, viewModel: viewModel)
        viewController.tabBarItem.tag = 1
        viewController.tabBarItem.title = "Album Scores"
        viewController.tabBarItem.image = UIImage(named: "ruler")

        return viewController
    }
}

extension ResourceLocator {
    static var scores: ResourceLocator {
        return ResourceLocator(identifier: scoresIdentifier, data: nil)
    }
}
