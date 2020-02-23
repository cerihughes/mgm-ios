import Foundation
import Madog

let mgmServiceProviderName = "mgmServiceProviderName"

protocol MGMServiceProvider {
    var localStorage: LocalStorage { get }
    var dataLoader: DataLoader { get }
    var gcpDataLoader: GCPDataLoader { get }
    var cachingGCPDataLoader: GCPDataLoader { get }
    var dataConverter: GCPDataConverter { get }
    var imageLoader: ImageLoader { get }
    var viewModelDataLoader: ViewModelDataLoader { get }
}

class MGMServiceProviderImplementation: ServiceProvider, MGMServiceProvider {
    let localStorage: LocalStorage
    let dataLoader: DataLoader
    let gcpDataLoader: GCPDataLoader
    let cachingGCPDataLoader: GCPDataLoader
    let dataConverter: GCPDataConverter
    let imageLoader: ImageLoader
    let viewModelDataLoader: ViewModelDataLoader

    // MARK: ServiceProvider

    override init(context: ServiceProviderCreationContext) {
        localStorage = UserDefaults.standard
        dataLoader = DataLoaderImplementation()
        gcpDataLoader = GCPDataLoaderImplementation(dataLoader: dataLoader)
        cachingGCPDataLoader = CachingGCPDataLoaderImplementation(wrappedDataLoader: gcpDataLoader, localStorage: localStorage)
        dataConverter = GCPDataConverterImplementation()

        imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: cachingGCPDataLoader, dataConverter: dataConverter)

        super.init(context: context)
        name = mgmServiceProviderName
    }
}
