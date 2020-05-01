import UIKit

protocol SettingsViewModel {}

class SettingsViewModelImplementation: SettingsViewModel {
    private let dataRepository: DataRepository

    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
    }
}
