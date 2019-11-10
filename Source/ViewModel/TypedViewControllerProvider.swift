import Madog
import UIKit

class TypedViewControllerProvider: ViewControllerProvider<ResourceLocator> {
    private var uuid: UUID?

    // MARK: ViewControllerProvider

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
