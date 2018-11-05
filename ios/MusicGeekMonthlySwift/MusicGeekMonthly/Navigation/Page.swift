import UIKit

/// A protocol that describes a page that wants to provide a VC (or a number of VCs) for a given token by registering
/// with a ViewControllerRegistry.
protocol Page {
    func register<T>(with registry: ViewControllerRegistry<T>)
}

protocol PageFactory {
    static func createPage() -> Page
}
