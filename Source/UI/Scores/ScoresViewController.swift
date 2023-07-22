import Madog
import UIKit

private let cellReuseIdentifier = "ScoresViewController_CellReuseIdentifier"

class ScoresViewController: ForwardNavigatingViewController {
    private var viewModel: ScoresViewModel
    private let scoresView = ScoresView()

    init(navigationContext: AnyForwardBackNavigationContext<Navigation>, viewModel: ScoresViewModel) {
        self.viewModel = viewModel

        super.init(navigationContext: navigationContext)
    }

    override func loadView() {
        view = scoresView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scoresView.collectionView.register(
            ScoresCollectionViewCell.self,
            forCellWithReuseIdentifier: cellReuseIdentifier
        )
        scoresView.collectionView.dataSource = self
        scoresView.collectionView.delegate = self

        scoresView.searchBar.placeholder = viewModel.filterPlaceholder
        scoresView.searchBar.delegate = self

        scoresView.retryButton.setTitle(viewModel.retryButtonTitle, for: .normal)
        scoresView.retryButton.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)

        let segmentedControl = UISegmentedControl(items: viewModel.albumTypes)
        segmentedControl.selectedSegmentIndex = viewModel.selectedAlbumType
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapGesture(sender:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl

        loadData()
    }

    private func loadData() {
        scoresView.hideMessage()
        scoresView.showActivityIndicator()
        viewModel.loadData { [weak self] in
            self?.scoresView.hideActivityIndicator()
            self?.updateUI()
        }
    }

    // MARK: Private

    private func updateUI() {
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
        viewModel.numberOfScores
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let scoresCell = cell as? ScoresCollectionViewCell else { return cell }

        if let viewData = viewModel.scoreViewData(at: indexPath.row) {
            scoresCell.albumLabel.text = viewData.albumName
            scoresCell.artistLabel.text = viewData.artistName
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard
            let viewData = viewModel.scoreViewData(at: indexPath.row),
            let scoresCell = cell as? ScoresCollectionViewCell,
            let layout = collectionView.collectionViewLayout as? FullWidthCollectionViewLayout
        else {
            return
        }

        scoresCell.imageView.image = viewData.loadingImage

        scoresCell.positionLabel.text = viewData.position
        scoresCell.ratingLabel.text = viewData.rating
        scoresCell.ratingLabel.textColor = viewData.ratingFontColor
        scoresCell.awardImageView.image = viewData.awardImage

        scoresCell.showActivityIndicator()

        let contentViewHeight = layout.contentViewSize(in: indexPath.section).height
        let largestDimension = Int(contentViewHeight * collectionView.traitCollection.displayScale)

        viewModel.loadAlbumCover(largestDimension: largestDimension, viewData: viewData) { image in
            scoresCell.hideActivityIndicator()
            if let image {
                scoresCell.imageView.image = image
            }
        }
    }

    func collectionView(_: UICollectionView, didEndDisplaying _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewData = viewModel.scoreViewData(at: indexPath.row) else { return }
        viewModel.cancelLoadAlbumCover(viewData: viewData)
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()

        guard
            let viewData = viewModel.scoreViewData(at: indexPath.row),
            let spotifyURL = viewData.spotifyURL
        else {
            return
        }

        let rl = Navigation.spotify(spotifyURL: spotifyURL)
        navigationContext?.navigateForward(token: rl, animated: true)
    }

    private func dismissKeyboard() {
        scoresView.searchBar.resignFirstResponder()
    }
}

extension ScoresViewController: UISearchBarDelegate {
    // MARK: UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Wait a second so that we don't update the UI while typing is ongoing...
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Get the filter a second time and only apply it if the value is the same as it was a second ago...
            guard let searchText2 = searchBar.text, searchText == searchText2 else { return }
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
