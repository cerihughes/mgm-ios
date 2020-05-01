import Foundation

protocol LocalStorage: AnyObject {
    var localNotificationsEnabled: Bool { get set }
    var eventData: Data? { get set }
}

private let localNotificationsEnabledKey = "LocalStorage_localNotificationsEnabledKey"
private let eventDataKey = "CachingGCPDataLoaderImplementation_userDefaultsKey"

extension UserDefaults: LocalStorage {
    var localNotificationsEnabled: Bool {
        get {
            return bool(forKey: localNotificationsEnabledKey)
        }
        set {
            set(newValue, forKey: localNotificationsEnabledKey)
        }
    }

    var eventData: Data? {
        get {
            return data(forKey: eventDataKey)
        }
        set {
            set(newValue, forKey: eventDataKey)
        }
    }
}
