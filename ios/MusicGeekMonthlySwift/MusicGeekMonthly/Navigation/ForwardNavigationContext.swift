import Foundation

protocol ForwardNavigationContext: class {
    func navigate<T>(with token: T, animated: Bool) -> Bool
}
