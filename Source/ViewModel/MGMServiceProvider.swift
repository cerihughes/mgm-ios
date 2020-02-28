import Foundation
import Madog

let mgmServiceProviderName = "mgmServiceProviderName"

protocol MGMServiceProvider {
    var localStorage: LocalStorage { get }
    var localDataSource: LocalDataSource { get }
    var remoteDataSource: RemoteDataSource { get }
    var eventUpdateManager: EventUpdateManager { get }
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

    // MARK: ServiceProvider

    override init(context: ServiceProviderCreationContext) {
        localStorage = UserDefaults.standard
        localDataSource = LocalDataSourceImplementation(localStorage: localStorage)

        let dataLoader = DataLoaderImplementation()
        remoteDataSource = RemoteDataSourceImplementation(dataLoader: dataLoader)

        eventUpdateManager = EventUpdateManagerImplementation()
        localNotificationsManager = LocalNotificationsManagerImplementation(notificationCenter: .current())

        dataRepository = DataRepositoryImplementation(localDataSource: localDataSource,
                                                      remoteDataSource: remoteDataSource,
                                                      eventUpdateManager: eventUpdateManager,
                                                      localNotificationsManager: localNotificationsManager)
        imageLoader = ImageLoaderImplementation(dataLoader: dataLoader)

        super.init(context: context)
        name = mgmServiceProviderName
    }
}
