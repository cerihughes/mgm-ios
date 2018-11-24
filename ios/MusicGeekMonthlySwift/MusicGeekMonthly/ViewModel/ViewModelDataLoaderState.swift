import Foundation
import Madog

let viewModelDataLoaderStateName = "viewModelDataLoaderStateName"

class ViewModelDataLoaderState: StateFactory, State {
    let imageLoader: ImageLoader
    let viewModelDataLoader: ViewModelDataLoader

    // MARK: StateFactory

    static func createState() -> State {
        return ViewModelDataLoaderState()
    }

    // MARK: State

    let name = viewModelDataLoaderStateName

    init() {
        let dataLoader = DataLoaderImplementation()
        let gcpDataLoader = GCPDataLoaderImplementation(dataLoader: dataLoader)
        let cachingGCPDataLoader = CachingGCPDataLoaderImplementation(wrappedDataLoader: gcpDataLoader, userDefaults: UserDefaults.standard)
        let dataConverter = GCPDataConverterImplementation()

        self.imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
        self.viewModelDataLoader = ViewModelDataLoaderImplementation(dataLoader: cachingGCPDataLoader, dataConverter: dataConverter)
    }
}
