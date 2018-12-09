import Madog
import UIKit

fileprivate let scoresIdentifier = "scoresIdentifier"

class ScoresPage: PageObject {
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
            token.identifier == scoresIdentifier,
            let navigationContext = context as? ForwardBackNavigationContext else {
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
