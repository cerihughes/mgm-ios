import Madog
import UIKit

fileprivate let latestEventIdentifier = "latestEventIdentifier"

class LatestEventViewControllerProvider: TypedViewControllerProviderObject {
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
        guard resourceLocator.identifier == latestEventIdentifier,
            let imageLoader = imageLoader,
            let viewModelDataLoader = viewModelDataLoader else {
                return nil
        }

        let viewModel = LatestEventViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
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
