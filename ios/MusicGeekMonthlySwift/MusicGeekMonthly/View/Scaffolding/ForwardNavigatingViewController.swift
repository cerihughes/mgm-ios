import Madog
import UIKit

class ForwardNavigatingViewController: UIViewController {
    let navigationContext: TabBarNavigationContext

    init(navigationContext: TabBarNavigationContext) {
        self.navigationContext = navigationContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
