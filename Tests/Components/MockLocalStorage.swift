import Foundation

@testable import MusicGeekMonthly

class MockLocalStorage: LocalStorage {
    var localNotificationsEnabled = false
    var eventData: Data?
}
