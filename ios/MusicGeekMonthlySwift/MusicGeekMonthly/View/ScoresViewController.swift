import UIKit

class ScoresViewController: UIViewController {
    private let viewModel: ScoresViewModel

    init(viewModel: ScoresViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.loadData { [unowned self] in
            print(self.viewModel.numberOfScores)
        }
    }
}

