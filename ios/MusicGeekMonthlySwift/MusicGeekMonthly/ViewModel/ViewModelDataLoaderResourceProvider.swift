import Foundation
import Madog

let viewModelDataLoaderResourceName = "viewModelDataLoaderResourceName"

class ViewModelDataLoaderResourceProvider: ResourceProviderObject {
    let imageLoader: ImageLoader
    let viewModelDataLoader: ViewModelDataLoader

    // MARK: ResourceProviderObject

    required init(context: ResourceProviderCreationContext) {
        let dataLoader = DataLoaderImplementation()
        let gcpDataLoader = GCPDataLoaderImplementation(dataLoader: dataLoader)
        let cachingGCPDataLoader = CachingGCPDataLoaderImplementation(wrappedDataLoader: gcpDataLoader, userDefaults: UserDefaults.standard)
        let dataConverter = GCPDataConverterImplementation()

        self.imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        self.viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: cachingGCPDataLoader, dataConverter: dataConverter)

        super.init(context: context)
        name = viewModelDataLoaderResourceName
    }
}
