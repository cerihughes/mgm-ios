import Madog
import UIKit

class TypedViewControllerProvider: ViewControllerProvider<ResourceLocator> {
    private var uuid: UUID?

    var serviceProvider: MGMServiceProvider?

    // MARK: ViewControllerProvider

    final override func configure(with serviceProviders: [String: ServiceProvider]) {
        super.configure(with: serviceProviders)

        serviceProvider = serviceProviders[mgmServiceProviderName] as? MGMServiceProvider
    }

    final override func register(with registry: Registry<ResourceLocator>) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    final override func unregister(from registry: Registry<ResourceLocator>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    func createViewController(resourceLocator _: ResourceLocator, navigationContext _: ForwardBackNavigationContext) -> UIViewController? {
        // Override
        return nil
    }

    // MARK: Private

    private func createViewController(token: ResourceLocator, context: Context) -> UIViewController? {
        guard let navigationContext = context as? ForwardBackNavigationContext else {
            return nil
        }

        return createViewController(resourceLocator: token, navigationContext: navigationContext)
    }
}
