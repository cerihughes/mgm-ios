import Foundation
import Madog

let viewModelDataLoaderStateName = "viewModelDataLoaderStateName"

class ViewModelDataLoaderState: StateObject {
    let imageLoader: ImageLoader
    let viewModelDataLoader: ViewModelDataLoader

    // MARK: StateObject


    required init() {
        let dataLoader = DataLoaderImplementation()
        let gcpDataLoader = GCPDataLoaderImplementation(dataLoader: dataLoader)
        let cachingGCPDataLoader = CachingGCPDataLoaderImplementation(wrappedDataLoader: gcpDataLoader, userDefaults: UserDefaults.standard)
        let dataConverter = GCPDataConverterImplementation()

        self.imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        self.viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: cachingGCPDataLoader, dataConverter: dataConverter)

        super.init()
        name = viewModelDataLoaderStateName
    }
}
