import UIKit

fileprivate let cellReuseIdentifier = "ScoresViewController_CellReuseIdentifier"

class ScoresViewController: ForwardNavigatingViewController {
    private var viewModel: ScoresViewModel

    init(forwardNavigationContext: ForwardNavigationContext, viewModel: ScoresViewModel) {
        self.viewModel = viewModel

        super.init(forwardNavigationContext: forwardNavigationContext)
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
        view.searchBar.placeholder = viewModel.filterPlaceholder
        view.searchBar.delegate = self
    }

    // MARK: Private

    private func updateUI() {
        guard let scoresView = view as? ScoresView else {
            return
        }

        if let message = viewModel.message {
            scoresView.showMessage(message)
        } else {
            scoresView.showResults()
            scoresView.collectionView.reloadData()
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
            let layout = collectionView.collectionViewLayout as? FullWidthCollectionViewLayout
            else {
                return
        }

        scoresCell.imageView.image = cellViewModel.loadingImage

        scoresCell.positionLabel.text = cellViewModel.position
        scoresCell.ratingLabel.text = cellViewModel.rating
        scoresCell.ratingLabel.textColor = cellViewModel.ratingFontColor
        scoresCell.awardImageView.image = cellViewModel.awardImage

        scoresCell.showActivityIndicator()

        let imageViewSize = layout.contentViewSize
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()

        guard
            let cellViewModel = viewModel.scoreViewModel(at: indexPath.row),
            let spotifyURLString = cellViewModel.spotifyURLString
            else {
                return
        }

        let rl = ResourceLocator.createSpotifyResourceLocator(spotifyURLString: spotifyURLString)
        _ = forwardNavigationContext.navigate(with: rl, from: self, animated: true)
    }

    private func dismissKeyboard() {
        guard let scoresView = view as? ScoresView else {
            return
        }
        scoresView.searchBar.resignFirstResponder()
    }
}

extension ScoresViewController: UISearchBarDelegate {

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Wait a second so that we don't update the UI while typing is ongoing...
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            // Get the filter a second time and only apply iy if the value is the same as it was a second ago...
            guard let searchText2 = searchBar.text, searchText == searchText2 else {
                return
            }

            self.viewModel.filter = searchBar.text
            self.updateUI()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.searchBar(searchBar, textDidChange: "")
        dismissKeyboard()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
