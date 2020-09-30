import Madog
import UIKit

class SettingsViewControllerProvider: TypedViewControllerProvider {
    // MARK: TypedViewControllerProvider

    override func createViewController(token: Navigation, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        guard
            token == .settings,
            let localNotificationsManager = serviceProvider?.localNotificationsManager
        else {
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
