import UIKit

protocol ForwardNavigationContext: class {
    func navigate<T>(with token: T, from fromViewController: UIViewController, animated: Bool) -> Bool
}
