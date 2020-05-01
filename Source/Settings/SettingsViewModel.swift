import UIKit

protocol SettingsViewModel {
    var title: String { get }
    var localNotificationsTitle: String { get }
    var localNotificationsSubtitle: String { get }
}

class SettingsViewModelImplementation: SettingsViewModel {
    let title = "Settings"
    let localNotificationsTitle = "Enable Local Notifications (beta)"
    let localNotificationsSubtitle = "Sends notifications when new events, albums scores and playlists become available."
    private let localNotificationsManager: LocalNotificationsManager

    init(localNotificationsManager: LocalNotificationsManager) {
        self.localNotificationsManager = localNotificationsManager
    }
}
