import Madog
import UIKit

class LatestEventPage: PageFactory, StatefulPage {
    private var imageLoader: ImageLoader?
    private var viewModelDataLoader: ViewModelDataLoader?
    private var uuid: UUID?

    // MARK: PageFactory

    static func createPage() -> Page {
        return LatestEventPage()
    }

    // MARK: Page

    func configure(with state: [String : State]) {
        if let viewModelDataLoaderState = state[viewModelDataLoaderStateName] as? ViewModelDataLoaderState {
            imageLoader = viewModelDataLoaderState.imageLoader
            viewModelDataLoader = viewModelDataLoaderState.viewModelDataLoader
        }
    }

    func register<Token, Context>(with registry: ViewControllerRegistry<Token, Context>) {
        uuid = registry.add(initialRegistryFunction: createViewController(context:))
    }

    func unregister<Token, Context>(from registry: ViewControllerRegistry<Token, Context>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController<Context>(context: Context) -> UIViewController? {
        guard
            let imageLoader = imageLoader,
            let viewModelDataLoader = viewModelDataLoader,
            let navigationContext = context as? TabBarNavigationContext else {
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
