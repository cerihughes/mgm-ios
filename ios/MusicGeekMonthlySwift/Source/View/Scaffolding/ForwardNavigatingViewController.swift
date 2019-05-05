import Madog
import UIKit

class ForwardNavigatingViewController: UIViewController {
    let navigationContext: ForwardBackNavigationContext

    init(navigationContext: ForwardBackNavigationContext) {
        self.navigationContext = navigationContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
