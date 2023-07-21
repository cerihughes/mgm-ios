import Foundation
import Madog

let mgmServiceProviderName = "mgmServiceProviderName"

protocol MGMServiceProvider {
    var localNotificationsManager: LocalNotificationsManager { get }
    var dataRepository: DataRepository { get }
    var imageLoader: ImageLoader { get }
}

class MGMServiceProviderImplementation: ServiceProvider, MGMServiceProvider {
    let localStorage: LocalStorage
    var localDataSource: LocalDataSource
    var remoteDataSource: RemoteDataSource
    let eventUpdateManager: EventUpdateManager
    let localNotificationsManager: LocalNotificationsManager
    var dataRepository: DataRepository
    let imageLoader: ImageLoader

    let name = mgmServiceProviderName

    // MARK: ServiceProvider

    required init(context: ServiceProviderCreationContext) {
        localStorage = UserDefaults.standard
        localDataSource = LocalDataSourceImplementation(localStorage: localStorage)

        let basePath = "https://mgm-gcp.appspot.com"
        remoteDataSource = RemoteDataSourceImplementation(basePath: basePath)

        eventUpdateManager = EventUpdateManagerImplementation()
        localNotificationsManager = LocalNotificationsManagerImplementation(localDataSource: localDataSource,
                                                                            notificationCenter: .current())

        dataRepository = DataRepositoryImplementation(localDataSource: localDataSource,
                                                      remoteDataSource: remoteDataSource,
                                                      eventUpdateManager: eventUpdateManager,
                                                      localNotificationsManager: localNotificationsManager)

        let dataLoader = DataLoaderImplementation()
        imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)
    }
}
