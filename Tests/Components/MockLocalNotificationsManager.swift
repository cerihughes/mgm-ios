import Foundation

@testable import MusicGeekMonthly

class MockLocalNotificationsManager: LocalNotificationsManager {
    var isEnabled = false
    var getAuthorizationStatusResponse = AuthorizationStatus.notDetermined
    var requestAuthorizationResponse = false
    var scheduleLocalNotifications = [EventUpdate]()

    func getAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void) {
        let response = getAuthorizationStatusResponse
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
