import UIKit

/// A protocol that describes an entity that wants to provide a VC for a given RegistrationLocator token by registering
/// with the ViewControllerRegistry.
protocol ViewControllerProvider {
    func register<T>(with registry: ViewControllerRegistry<T>)
}

protocol ViewControllerProviderFactory {
    static func createViewControllerProvider() -> ViewControllerProvider
}
