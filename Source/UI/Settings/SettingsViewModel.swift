import UIKit

enum LocalNotificationsState {
    case updated(Bool), updateDenied, alreadyDenied
}

protocol SettingsViewModel {
    var title: String { get }
    var localNotificationsTitle: String { get }
    var localNotificationsSubtitle: String { get }

    var localNotificationsDisabledTitle: String { get }
    var localNotificationsDisabledMessage: String { get }

    func getLocalNotificationsState(completion: @escaping (Bool) -> Void)
    func updateLocalNotificationsState(_ value: Bool, completion: @escaping (LocalNotificationsState) -> Void)
}

class SettingsViewModelImplementation: SettingsViewModel {
    let title = "Settings"
    let localNotificationsTitle = "Enable Local Notifications (beta)"
    let localNotificationsSubtitle =
        "Sends notifications when new events, albums scores and playlists become available."
    let localNotificationsDisabledTitle = "Local Notifications Disabled"
    let localNotificationsDisabledMessage =
        "Notifications have been disabled for this app. Go into your device's settings to change this."

    private let localNotificationsManager: LocalNotificationsManager

    init(localNotificationsManager: LocalNotificationsManager) {
        self.localNotificationsManager = localNotificationsManager
    }

    func getLocalNotificationsState(completion: @escaping (Bool) -> Void) {
        let localValue = localNotificationsManager.isEnabled
        localNotificationsManager.getAuthorizationStatus { completion($0 == .authorized && localValue) }
    }

    func updateLocalNotificationsState(_ value: Bool, completion: @escaping (LocalNotificationsState) -> Void) {
        doUpdateLocalNotificationsState(value) { [weak self] state in
            switch state {
            case let .updated(value):
                self?.localNotificationsManager.isEnabled = value
            default:
                self?.localNotificationsManager.isEnabled = false
            }
            completion(state)
        }
    }

    private func doUpdateLocalNotificationsState(
        _ value: Bool,
        completion: @escaping (LocalNotificationsState) -> Void
    ) {
        if value == true {
            requestAuthorizationIfNeeded(completion: completion)
        } else {
            completion(.updated(false))
        }
    }

    private func requestAuthorizationIfNeeded(completion: @escaping (LocalNotificationsState) -> Void) {
        localNotificationsManager.getAuthorizationStatus { [weak self] status in
            guard let self else {
                completion(.alreadyDenied)
                return
            }
            switch status {
            case .notDetermined:
                self.localNotificationsManager.requestAuthorization { result in
                    completion(result == true ? .updated(true) : .updateDenied)
                }
            case .authorized:
                completion(.updated(true))
            case .denied:
                completion(.alreadyDenied)
            }
        }
    }
}
