import UIKit

protocol SettingsViewModel {
    var title: String { get }
    var localNotificationsText: String { get }
}

class SettingsViewModelImplementation: SettingsViewModel {
    let title = "Settings"
    let localNotificationsText = "Enable Local Notifications (beta)"
    private let localNotificationsManager: LocalNotificationsManager

    init(localNotificationsManager: LocalNotificationsManager) {
        self.localNotificationsManager = localNotificationsManager
    }
}
