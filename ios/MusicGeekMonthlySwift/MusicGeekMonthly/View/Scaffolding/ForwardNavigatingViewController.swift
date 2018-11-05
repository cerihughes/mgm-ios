import UIKit

class ForwardNavigatingViewController: UIViewController {
    let forwardNavigationContext: ForwardNavigationContext

    init(forwardNavigationContext: ForwardNavigationContext) {
        self.forwardNavigationContext = forwardNavigationContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
