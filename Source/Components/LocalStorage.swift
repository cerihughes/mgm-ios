import Foundation

protocol LocalStorage {
    var eventData: Data? { get nonmutating set }
}

private let eventDataKey = "CachingGCPDataLoaderImplementation_userDefaultsKey"

extension UserDefaults: LocalStorage {
    var eventData: Data? {
        get {
            return data(forKey: eventDataKey)
        }
        set {
            set(newValue, forKey: eventDataKey)
        }
    }
}
