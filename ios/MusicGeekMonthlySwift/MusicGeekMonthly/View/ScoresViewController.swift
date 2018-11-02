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

        view.collectionView.register(ScoresCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
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
            ratesView.collectionView.reloadData()
        }
    }
}

extension ScoresViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfScores
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let scoresCell = cell as? ScoresCollectionViewCell else {
            return cell
        }

        if let cellViewModel = viewModel.scoreViewModel(at: indexPath.row) {
            scoresCell.albumLabel.text = cellViewModel.albumName
            scoresCell.artistLabel.text = cellViewModel.artistName
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let cellViewModel = viewModel.scoreViewModel(at: indexPath.row),
            let scoresCell = cell as? ScoresCollectionViewCell,
            let layout = collectionView.collectionViewLayout as? ScoresCollectionViewLayout
            else {
                return
        }

        scoresCell.imageView.image = cellViewModel.loadingImage
        scoresCell.showActivityIndicator()

        let imageViewSize = layout.imageViewSize
        let largestDimension = Int(max(imageViewSize.width, imageViewSize.height) * collectionView.traitCollection.displayScale)

        cellViewModel.loadAlbumCover(largestDimension: largestDimension) { (image) in
            scoresCell.hideActivityIndicator()
            if let image = image {
                scoresCell.imageView.image = image
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.scoreViewModel(at: indexPath.row) else {
            return
        }

        cellViewModel.cancelLoadAlbumCover()
    }
}
