import UIKit

/// Implementations of PageLoader should return an array of each of the app's PageFactory implementations so that they
/// can create a Page and registered it with the registry.
///
/// At the moment, the only implementation is the RuntimePageLoader which uses Runtime magic to find all loaded classes
/// that implement PageFactory. This is used to create a Page.
///
/// This might not be a long term solution, especially if Swift moves away from the Obj-C runtime, but it does serve as
/// a nice example of accessing the Obj-C runtime from Swift.
///
/// Other implementations can be written that (e.g.) manually instantiate the required implementations, or maybe load
/// them via a plist.
protocol PageLoader {
    func pageFactories() -> [PageFactory.Type]
}
