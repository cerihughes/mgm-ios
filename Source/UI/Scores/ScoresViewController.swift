import Madog
import UIKit

private let cellReuseIdentifier = "ScoresViewController_CellReuseIdentifier"

class ScoresViewController: ForwardNavigatingViewController {
    private var viewModel: ScoresViewModel

    init(navigationContext: ForwardBackNavigationContext, viewModel: ScoresViewModel) {
        self.viewModel = viewModel

        super.init(navigationContext: navigationContext)
    }

    required init?(coder _: NSCoder) {
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

        view.collectionView.register(ScoresCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.collectionView.dataSource = self
        view.collectionView.delegate = self

        view.searchBar.placeholder = viewModel.filterPlaceholder
        view.searchBar.delegate = self

        view.retryButton.setTitle(viewModel.retryButtonTitle, for: .normal)
        view.retryButton.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)

        let segmentedControl = UISegmentedControl(items: viewModel.albumTypes)
        segmentedControl.selectedSegmentIndex = viewModel.selectedAlbumType
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapGesture(sender:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl

        loadData()
    }

    private func loadData() {
        guard let view = view as? ScoresView else {
            return
        }

        view.hideMessage()
        view.showActivityIndicator()
        viewModel.loadData { [weak self] in
            view.hideActivityIndicator()
            self?.updateUI()
        }
    }

    // MARK: Private

    private func updateUI() {
        guard let scoresView = view as? ScoresView else {
            return
        }

        if let message = viewModel.message {
            scoresView.showMessage(message, showRetryButton: !viewModel.dataLoaded)
        } else {
            scoresView.showResults()
            scoresView.collectionView.reloadData()
        }
    }
}

extension ScoresViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: UICollectionViewDataSource

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
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

        let contentViewHeight = layout.contentViewSize(in: indexPath.section).height
        let largestDimension = Int(contentViewHeight * collectionView.traitCollection.displayScale)

        cellViewModel.loadAlbumCover(largestDimension: largestDimension) { image in
            scoresCell.hideActivityIndicator()
            if let image = image {
                scoresCell.imageView.image = image
            }
        }
    }

    func collectionView(_: UICollectionView, didEndDisplaying _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel.scoreViewModel(at: indexPath.row) else {
            return
        }

        cellViewModel.cancelLoadAlbumCover()
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()

        guard
            let cellViewModel = viewModel.scoreViewModel(at: indexPath.row),
            let spotifyURL = cellViewModel.spotifyURL
        else {
            return
        }

        let rl = Navigation.spotify(spotifyURL: spotifyURL)
        _ = navigationContext.navigateForward(token: rl, animated: true)
    }

    private func dismissKeyboard() {
        guard let scoresView = view as? ScoresView else {
            return
        }
        scoresView.searchBar.resignFirstResponder()
    }
}

extension ScoresViewController: UISearchBarDelegate {
    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Wait a second so that we don't update the UI while typing is ongoing...
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Get the filter a second time and only apply it if the value is the same as it was a second ago...
            guard let searchText2 = searchBar.text, searchText == searchText2 else {
                return
            }

            self?.viewModel.filter = searchBar.text
            self?.updateUI()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.searchBar(searchBar, textDidChange: "")
        dismissKeyboard()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        dismissKeyboard()
    }
}

extension ScoresViewController {
    // MARK: UIButton interactions

    @objc
    private func buttonTapGesture(sender _: UIButton) {
        loadData()
    }
}

extension ScoresViewController {
    // MARK: UISegmentedControl interactions

    @objc
    private func segmentedControlTapGesture(sender: UISegmentedControl) {
        viewModel.selectedAlbumType = sender.selectedSegmentIndex
        updateUI()
    }
}
