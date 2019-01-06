import Madog
import UIKit

fileprivate let latestEventIdentifier = "latestEventIdentifier"

class LatestEventViewControllerProvider: ViewControllerProviderObject {
    private var imageLoader: ImageLoader?
    private var viewModelDataLoader: ViewModelDataLoader?
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    override func configure(with resourceProviders: [String : ResourceProvider]) {
        if let resourceProvider = resourceProviders[viewModelDataLoaderResourceName] as? ViewModelDataLoaderResourceProvider {
            imageLoader = resourceProvider.imageLoader
            viewModelDataLoader = resourceProvider.viewModelDataLoader
        }
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard
            let imageLoader = imageLoader,
            let viewModelDataLoader = viewModelDataLoader,
            let token = token as? ResourceLocator,
            token.identifier == latestEventIdentifier,
            let navigationContext = context as? ForwardBackNavigationContext else {
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
    static func latestEvent() -> ResourceLocator {
        return ResourceLocator(identifier: latestEventIdentifier, data: nil)
    }
}
