import UIKit

class ScoresPage: PageFactory, Page {

    // MARK: PageFactory

    static func createPage() -> Page {
        return ScoresPage()
    }

    // MARK: Page

    func register<T>(with registry: ViewControllerRegistry<T>) {
        _ = registry.add(initialRegistryFunction: createViewController(forwardNavigationContext:))
    }

    // MARK: Private

    private func createViewController(forwardNavigationContext: ForwardNavigationContext) -> UIViewController {
        let dataLoader = DataLoaderImplementation()
        let googleSheetsDataLoader = GoogleSheetsDataLoaderImplementation(dataLoader: dataLoader)
        let imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        let dataConverter = DataConverterImplementation()
        let viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: googleSheetsDataLoader, dataConverter: dataConverter)
        let viewModel = ScoresViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
        let viewController = ScoresViewController(forwardNavigationContext: forwardNavigationContext, viewModel: viewModel)
        viewController.tabBarItem.title = "Album Scores"
        viewController.tabBarItem.image = UIImage(named: "ruler")

        return viewController
    }

}
