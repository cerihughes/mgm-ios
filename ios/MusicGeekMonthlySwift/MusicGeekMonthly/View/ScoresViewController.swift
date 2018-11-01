import UIKit

fileprivate let cellReuseIdentifier = "ScoresViewController_CellReuseIdentifier"

class ScoresViewController: UIViewController {
    private let viewModel: ScoresViewModel

    init(viewModel: ScoresViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ScoresView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view as? ScoresView else {
            return
        }

        viewModel.loadData { [unowned self] in
            self.updateUI()
        }

        navigationItem.title = viewModel.title

        view.tableView.dataSource = self
        view.tableView.delegate = self
    }

    // MARK: Private

    private func updateUI() {
        guard let ratesView = view as? ScoresView else {
            return
        }

        if let message = viewModel.message {
            ratesView.showMessage(message)
        } else {
            ratesView.showTableView()
            ratesView.tableView.reloadData()
        }
    }
}

extension ScoresViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfScores
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        if let cellViewModel = viewModel.scoreViewModel(at: indexPath.row) {
            cell.textLabel?.text = cellViewModel.albumName
            cell.detailTextLabel?.text = cellViewModel.artistName
        }
        return cell
    }
}
