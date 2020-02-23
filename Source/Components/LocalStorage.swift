import Foundation

protocol LocalStorage {
    var eventData: Data? { get nonmutating set }
}

private let eventDataKey = "LocalStorage_eventDataKey"

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
