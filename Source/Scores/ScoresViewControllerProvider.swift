import Madog
import UIKit

fileprivate let scoresIdentifier = "scoresIdentifier"

class ScoresViewControllerProvider: TypedViewControllerProvider {
    private var imageLoader: ImageLoader?
    private var viewModelDataLoader: ViewModelDataLoader?

    // MARK: ViewControllerProvider

    override func configure(with serviceProviders: [String : ServiceProvider]) {
        super.configure(with: serviceProviders)

        if let serviceProvider = serviceProviders[viewModelDataLoaderServiceName] as? ViewModelDataLoaderServiceProvider {
            imageLoader = serviceProvider.imageLoader
            viewModelDataLoader = serviceProvider.viewModelDataLoader
        }
    }

    // MARK: TypedViewControllerProvider

    override func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard resourceLocator.identifier == scoresIdentifier,
            let imageLoader = imageLoader,
            let viewModelDataLoader = viewModelDataLoader else {
                return nil
        }

        let viewModel = ScoresViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
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
