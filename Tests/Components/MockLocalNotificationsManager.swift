import Foundation

@testable import MusicGeekMonthly

class MockLocalNotificationsManager: LocalNotificationsManager {
    var isEnabled = false
    var isAuthorizedResponse = false
    var requestAuthorizationResponse = false
    var scheduleLocalNotifications = [EventUpdate]()

    func isAuthorized(completion: @escaping (Bool) -> Void) {
        let response = isAuthorizedResponse
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let response = requestAuthorizationResponse
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    func scheduleLocalNotification(eventUpdate: EventUpdate) {
        scheduleLocalNotifications.append(eventUpdate)
    }
}
