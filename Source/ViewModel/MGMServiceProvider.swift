import Foundation
import Madog

let mgmServiceProviderName = "mgmServiceProviderName"

protocol MGMServiceProvider {
    var localStorage: LocalStorage { get }
    var localDataSource: LocalDataSource { get }
    var remoteDataSource: RemoteDataSource { get }
    var dataRepository: DataRepository { get }
    var imageLoader: ImageLoader { get }
}

class MGMServiceProviderImplementation: ServiceProvider, MGMServiceProvider {
    let localStorage: LocalStorage
    var localDataSource: LocalDataSource
    var remoteDataSource: RemoteDataSource
    var dataRepository: DataRepository
    let imageLoader: ImageLoader

    // MARK: ServiceProvider

    override init(context: ServiceProviderCreationContext) {
        localStorage = UserDefaults.standard
        localDataSource = LocalDataSourceImplementation(localStorage: localStorage)

        let dataLoader = DataLoaderImplementation()
        remoteDataSource = RemoteDataSourceImplementation(dataLoader: dataLoader)
        dataRepository = DataRepositoryImplementation(localDataSource: localDataSource, remoteDataSource: remoteDataSource)
        imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)

        super.init(context: context)
        name = mgmServiceProviderName
    }
}
