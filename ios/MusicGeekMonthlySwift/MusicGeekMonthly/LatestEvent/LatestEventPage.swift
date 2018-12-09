import Madog
import UIKit

fileprivate let latestEventIdentifier = "latestEventIdentifier"

class LatestEventPage: PageObject {
    private var imageLoader: ImageLoader?
    private var viewModelDataLoader: ViewModelDataLoader?
    private var uuid: UUID?

    // MARK: PageObject

    override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    override func configure(with state: [String : State]) {
        if let viewModelDataLoaderState = state[viewModelDataLoaderStateName] as? ViewModelDataLoaderState {
            imageLoader = viewModelDataLoaderState.imageLoader
            viewModelDataLoader = viewModelDataLoaderState.viewModelDataLoader
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
