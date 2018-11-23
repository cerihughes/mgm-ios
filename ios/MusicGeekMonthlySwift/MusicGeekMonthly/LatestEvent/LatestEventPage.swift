import Madog
import UIKit

class LatestEventPage: PageFactory, Page {
    private var uuid: UUID?

    // MARK: PageFactory

    static func createPage() -> Page {
        return LatestEventPage()
    }

    // MARK: Page

    func register<Token, Context>(with registry: ViewControllerRegistry<Token, Context>) {
        uuid = registry.add(globalRegistryFunction: createViewController(context:))
    }

    func unregister<Token, Context>(from registry: Registry<Token, Context, UIViewController>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeGlobalRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController<Context>(context: Context) -> UIViewController? {
        guard let forwardNavigationContext = context as? ForwardNavigationContext else {
            return nil
        }

        let dataLoader = DataLoaderImplementation()
        let gcpDataLoader = GCPDataLoaderImplementation(dataLoader: dataLoader)
        let cachingGCPDataLoader = CachingGCPDataLoaderImplementation(wrappedDataLoader: gcpDataLoader, userDefaults: UserDefaults.standard)
        let imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        let dataConverter = GCPDataConverterImplementation()
        let viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: cachingGCPDataLoader, dataConverter: dataConverter)
        let viewModel = LatestEventViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
        let viewController = LatestEventViewController(forwardNavigationContext: forwardNavigationContext, viewModel: viewModel)
        viewController.tabBarItem.title = "Latest Event"
        viewController.tabBarItem.image = UIImage(named: "calendar")

        return viewController

    }
}
