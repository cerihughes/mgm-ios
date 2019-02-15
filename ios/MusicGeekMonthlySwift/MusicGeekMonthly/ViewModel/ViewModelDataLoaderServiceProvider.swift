import Foundation
import Madog

let viewModelDataLoaderServiceName = "viewModelDataLoaderServiceName"

class ViewModelDataLoaderServiceProvider: ServiceProviderObject {
    let imageLoader: ImageLoader
    let viewModelDataLoader: ViewModelDataLoader

    // MARK: ServiceProviderObject

    required init(context: ServiceProviderCreationContext) {
        let dataLoader = DataLoaderImplementation()
        let gcpDataLoader = GCPDataLoaderImplementation(dataLoader: dataLoader)
        let cachingGCPDataLoader = CachingGCPDataLoaderImplementation(wrappedDataLoader: gcpDataLoader, userDefaults: UserDefaults.standard)
        let dataConverter = GCPDataConverterImplementation()

        self.imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        self.viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: cachingGCPDataLoader, dataConverter: dataConverter)

        super.init(context: context)
        name = viewModelDataLoaderServiceName
    }
}
