import UIKit

protocol SettingsViewModel {
    var title: String { get }
    var localNotificationsText: String { get }
}

class SettingsViewModelImplementation: SettingsViewModel {
    let title = "Settings"
    let localNotificationsText = "Enable Local Notifications (beta)"
    private let dataRepository: DataRepository

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
}
