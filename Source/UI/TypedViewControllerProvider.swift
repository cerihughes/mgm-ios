import Madog
import UIKit

class TypedViewControllerProvider: SingleViewControllerProvider<ResourceLocator> {
    var serviceProvider: MGMServiceProvider?

    // MARK: SingleViewControllerProvider

    override final func configure(with serviceProviders: [String: ServiceProvider]) {
        super.configure(with: serviceProviders)

        serviceProvider = serviceProviders[mgmServiceProviderName] as? MGMServiceProvider
    }

    override func createViewController(token: ResourceLocator, context: Context) -> UIViewController? {
        guard let navigationContext = context as? ForwardBackNavigationContext else {
            return nil
        }

        return createViewController(resourceLocator: token, navigationContext: navigationContext)
    }

    func createViewController(resourceLocator _: ResourceLocator, navigationContext _: ForwardBackNavigationContext) -> UIViewController? {
        // Override
        return nil
    }
}
