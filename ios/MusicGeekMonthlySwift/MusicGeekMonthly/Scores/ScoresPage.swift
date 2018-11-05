import UIKit

class ScoresPage: ViewControllerProviderFactory, ViewControllerProvider {

    // MARK: ViewControllerProviderFactory

    static func createViewControllerProvider() -> ViewControllerProvider {
        return ScoresPage()
    }

    // MARK: ViewControllerProvider

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
        return ScoresViewController(forwardNavigationContext: forwardNavigationContext, viewModel: viewModel)
    }

}
