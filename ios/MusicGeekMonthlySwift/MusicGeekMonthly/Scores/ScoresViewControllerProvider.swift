import Madog
import UIKit

fileprivate let scoresIdentifier = "scoresIdentifier"

class ScoresViewControllerProvider: TypedViewControllerProviderObject {
    private var imageLoader: ImageLoader?
    private var viewModelDataLoader: ViewModelDataLoader?

    // MARK: ViewControllerProviderObject

    override func configure(with resourceProviders: [String : ResourceProvider]) {
        super.configure(with: resourceProviders)

        if let resourceProvider = resourceProviders[viewModelDataLoaderResourceName] as? ViewModelDataLoaderResourceProvider {
            imageLoader = resourceProvider.imageLoader
            viewModelDataLoader = resourceProvider.viewModelDataLoader
        }
    }

    // MARK: TypedViewControllerProviderObject

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
    static func scores() -> ResourceLocator {
        return ResourceLocator(identifier: scoresIdentifier, data: nil)
    }
}
