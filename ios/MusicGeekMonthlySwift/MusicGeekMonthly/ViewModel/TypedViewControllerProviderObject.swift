import Madog
import UIKit

class TypedViewControllerProviderObject: ViewControllerProviderObject {
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    final override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    final override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    func createViewController(resourceLocator: ResourceLocator, navigationContext: ForwardBackNavigationContext) -> UIViewController? {
        // Override
        return nil
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let resourceLocator = token as? ResourceLocator,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        return createViewController(resourceLocator: resourceLocator, navigationContext: navigationContext)
    }
}
