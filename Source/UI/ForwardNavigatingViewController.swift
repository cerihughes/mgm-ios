import Madog
import UIKit

class ForwardNavigatingViewController: UIViewController {
    weak var navigationContext: AnyForwardBackNavigationContext<Navigation>?

    init(navigationContext: AnyForwardBackNavigationContext<Navigation>) {
        self.navigationContext = navigationContext
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
