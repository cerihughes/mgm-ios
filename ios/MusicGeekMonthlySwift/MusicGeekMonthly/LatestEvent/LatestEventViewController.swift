import UIKit

fileprivate let cellReuseIdentifier = "LatestEventViewController_CellReuseIdentifier"

class LatestEventViewController: ForwardNavigatingViewController {
    private var viewModel: LatestEventViewModel

    init(forwardNavigationContext: ForwardNavigationContext, viewModel: LatestEventViewModel) {
        self.viewModel = viewModel

        super.init(forwardNavigationContext: forwardNavigationContext)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = LatestEventView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view as? LatestEventView else {
            return
        }

        viewModel.loadData { [unowned self] in
            self.updateUI()
        }

        navigationItem.title = viewModel.title

        view.collectionView.register(LatestEventCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
    }

    // MARK: Private

    private func updateUI() {
        guard let scoresView = view as? LatestEventView else {
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

extension LatestEventViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard
            let _ = viewModel.classicAlbumViewModel,
            let _ = viewModel.newAlbumViewModel
            else {
                return 0
        }
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard
            let eventCell = cell as? LatestEventCollectionViewCell,
            let albumViewModel = albumViewModel(for: indexPath)
            else {
                return cell
        }

        eventCell.typeLabel.text = albumViewModel.albumType
        eventCell.albumLabel.text = albumViewModel.albumName
        eventCell.artistLabel.text = albumViewModel.artistName

        return cell
    }

    private func albumViewModel(for indexPath: IndexPath) -> LatestEventAlbumViewModel? {
        switch indexPath.row {
        case 0:
            return viewModel.classicAlbumViewModel
        case 1:
            return viewModel.newAlbumViewModel
        default:
            return nil
        }
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let eventCell = cell as? LatestEventCollectionViewCell,
            let albumViewModel = albumViewModel(for: indexPath),
            let layout = collectionView.collectionViewLayout as? FullWidthCollectionViewLayout
            else {
                return
        }

        eventCell.imageView.image = albumViewModel.loadingImage

        eventCell.showActivityIndicator()

        let imageViewSize = layout.contentViewSize
        let largestDimension = Int(max(imageViewSize.width, imageViewSize.height) * collectionView.traitCollection.displayScale)

        albumViewModel.loadAlbumCover(largestDimension: largestDimension) { (image) in
            eventCell.hideActivityIndicator()
            if let image = image {
                eventCell.imageView.image = image
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let albumViewModel = albumViewModel(for: indexPath) else {
            return
        }

        albumViewModel.cancelLoadAlbumCover()
    }
}
