import UIKit

/// A registry that looks up view controllers for a given token <T>. This token should be a type that is able to uniquely
/// identify any "page" in an app, and also provide any data that the page needs to render. A good example would be a
/// URL object, but this isn't mandatory.
///
/// The registry works by registering a number of functions. To retrieve a page, the token <T> is passed into all
/// registered functions, and the 1st non-nil VC that comes back is used as the return value.
///
/// Note that registrants should make sure they don't "overlap" - if more than 1 registrant could potentially return a
/// VC for the same token, behaviour is undefined - there's no guarantee which will be returned first.
final class ViewControllerRegistry<T> {
    typealias InitialViewControllerRegistryFunction = (ForwardNavigationContext) -> UIViewController
    typealias ViewControllerRegistryFunction = (T, ForwardNavigationContext) -> UIViewController?

    private var initialRegistry: [UUID:InitialViewControllerRegistryFunction] = [:]
    private var registry: [UUID:ViewControllerRegistryFunction] = [:]

    weak var forwardNavigationContext: ForwardNavigationContext?

    func add(initialRegistryFunction: @escaping InitialViewControllerRegistryFunction) -> UUID {
        let token = UUID()
        initialRegistry[token] = initialRegistryFunction
        return token
    }

    func add(registryFunction: @escaping ViewControllerRegistryFunction) -> UUID {
        let token = UUID()
        registry[token] = registryFunction
        return token
    }

    func removeInitialRegistryFunction(token: UUID) {
        initialRegistry.removeValue(forKey: token)
    }

    func removeRegistryFunction(token: UUID) {
        registry.removeValue(forKey: token)
    }

    func createInitialViewController() -> UIViewController {
        guard let initialFunction = initialRegistry.values.first else {
            fatalError("No initial view controllers are registered")
        }

        guard let forwardNavigationContext = forwardNavigationContext else {
            fatalError("Forward navigation context not set")
        }

        if initialRegistry.count > 1 {
            print("Warning: More than 1 initial registry function is registered. There are no guarantees about which will be used.")
        }

        return initialFunction(forwardNavigationContext)
    }

    func createViewController(from token: T) -> UIViewController? {
        guard let forwardNavigationContext = forwardNavigationContext else {
            return nil
        }

        for function in registry.values {
            if let viewController = function(token, forwardNavigationContext) {
                return viewController
            }
        }
        return nil
    }
}
