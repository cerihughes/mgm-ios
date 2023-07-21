import Madog
import UIKit

class TypedViewControllerProvider: ViewControllerProvider {
    var serviceProvider: MGMServiceProvider?

    // MARK: ViewControllerProvider

    final func configure(with serviceProviders: [String: ServiceProvider]) {
        serviceProvider = serviceProviders[mgmServiceProviderName] as? MGMServiceProvider
    }

    func createViewController(token: Navigation, context: AnyContext<Navigation>) -> UIViewController? {
        guard let navigationContext = context as? AnyForwardBackNavigationContext<Navigation> else { return nil }
        return createViewController(token: token, navigationContext: navigationContext)
    }

    func createViewController(
        token: Navigation,
        navigationContext: AnyForwardBackNavigationContext<Navigation>
    ) -> UIViewController? {
        // Override
        nil
    }
}
