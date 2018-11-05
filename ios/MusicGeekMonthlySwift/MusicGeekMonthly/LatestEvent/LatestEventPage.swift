import UIKit

class LatestEventPage: ViewControllerProviderFactory, ViewControllerProvider {

    // MARK: ViewControllerProviderFactory

    static func createViewControllerProvider() -> ViewControllerProvider {
        return LatestEventPage()
    }

    // MARK: ViewControllerProvider

    func register<T>(with registry: ViewControllerRegistry<T>) {
//        _ = registry.add(initialRegistryFunction: createViewController(forwardNavigationContext:))
    }

    // MARK: Private

    private func createViewController(forwardNavigationContext: ForwardNavigationContext) -> UIViewController {
        let dataLoader = DataLoaderImplementation()
        let googleSheetsDataLoader = GoogleSheetsDataLoaderImplementation(dataLoader: dataLoader)
        let imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        let dataConverter = DataConverterImplementation()
        let viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: googleSheetsDataLoader, dataConverter: dataConverter)
        let viewModel = LatestEventViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
        return LatestEventViewController(forwardNavigationContext: forwardNavigationContext, viewModel: viewModel)
    }
}
