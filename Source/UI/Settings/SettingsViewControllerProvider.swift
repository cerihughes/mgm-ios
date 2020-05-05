import Madog
import UIKit

private let settingsIdentifier = "settings"

class SettingsViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard resourceLocator.identifier == settingsIdentifier,
            let localNotificationsManager = serviceProvider?.localNotificationsManager else {
            return nil
        }

        let viewModel = SettingsViewModelImplementation(localNotificationsManager: localNotificationsManager)
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.tabBarItem.tag = 2
        viewController.tabBarItem.title = "Settings"
        viewController.tabBarItem.image = UIImage(named: "ruler")

        return viewController
    }
}

extension ResourceLocator {
    static var settings: ResourceLocator {
        return ResourceLocator(identifier: settingsIdentifier, data: nil)
    }
}
