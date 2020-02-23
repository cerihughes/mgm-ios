import Madog
import UIKit

private let latestEventIdentifier = "latestEventIdentifier"

class LatestEventViewControllerProvider: TypedViewControllerProvider {
    private var imageLoader: ImageLoader?
    private var viewModelDataLoader: ViewModelDataLoader?

    // MARK: ViewControllerProvider

    override func configure(with serviceProviders: [String: ServiceProvider]) {
        super.configure(with: serviceProviders)

        if let serviceProvider = serviceProviders[mgmServiceProviderName] as? MGMServiceProvider {
            imageLoader = serviceProvider.imageLoader
            viewModelDataLoader = serviceProvider.viewModelDataLoader
        }
    }

    // MARK: TypedViewControllerProvider

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
