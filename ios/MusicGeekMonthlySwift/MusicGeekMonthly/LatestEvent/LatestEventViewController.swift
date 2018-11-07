import CoreLocation
import UIKit

fileprivate let locationCellReuseIdentifier = "LatestEventViewController_CellReuseIdentifier_Location"
fileprivate let entityCellReuseIdentifier = "LatestEventViewController_CellReuseIdentifier_Enity"

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

        view.collectionView.register(LatestEventLocationCollectionViewCell.self, forCellWithReuseIdentifier: locationCellReuseIdentifier)
        view.collectionView.register(LatestEventEntityCollectionViewCell.self, forCellWithReuseIdentifier: entityCellReuseIdentifier)

        view.collectionView.dataSource = self
        view.collectionView.delegate = self
    }

    // MARK: Private

    private func updateUI() {
        guard let scoresView = view as? LatestEventView else {
            return
        }

        navigationItem.title = viewModel.title

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

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewModel.numberOfLocations > 0 {
            return 2
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.numberOfLocations
        default:
            return viewModel.numberOfEntites
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return self.collectionView(collectionView, locationCellForItemAt:indexPath)
        }
        return self.collectionView(collectionView, entityCellForItemAt:indexPath)
    }

    private func collectionView(_ collectionView: UICollectionView, locationCellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: locationCellReuseIdentifier, for: indexPath)
        guard
            let mapReference = viewModel.mapReference,
            let locationName = viewModel.locationName,
            let locationCell = cell as? LatestEventLocationCollectionViewCell
            else {
                return cell
        }

        let location = CLLocation(latitude: mapReference.latitude, longitude: mapReference.longitude)
        locationCell.dropPin(at: location, title: locationName)

        return locationCell
    }

    private func collectionView(_ collectionView: UICollectionView, entityCellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: entityCellReuseIdentifier, for: indexPath)
        guard
            let entityCell = cell as? LatestEventEntityCollectionViewCell,
            let entityViewModel = viewModel.eventEntityViewModel(at: indexPath.row)
            else {
                return cell
        }

        entityCell.typeLabel.text = entityViewModel.entityType
        entityCell.albumLabel.text = entityViewModel.entityName
        entityCell.artistLabel.text = entityViewModel.entityOwner

        return entityCell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            indexPath.section == 1,
            let entityCell = cell as? LatestEventEntityCollectionViewCell,
            let entityViewModel = viewModel.eventEntityViewModel(at: indexPath.row),
            let layout = collectionView.collectionViewLayout as? FullWidthCollectionViewLayout
            else {
                return
        }

        entityCell.imageView.image = entityViewModel.loadingImage
        entityCell.backgroundImageView.image = entityViewModel.loadingImage

        entityCell.showActivityIndicator()

        let contentViewHeight = layout.contentViewSize(in: indexPath.section).height
        let largestDimension = Int(contentViewHeight * collectionView.traitCollection.displayScale)

        entityViewModel.loadAlbumCover(largestDimension: largestDimension) { (image) in
            entityCell.hideActivityIndicator()
            if let image = image {
                entityCell.backgroundImageView.image = image
                entityCell.imageView.image = image
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            indexPath.section == 1,
            let entityViewModel = viewModel.eventEntityViewModel(at: indexPath.row)
            else {
                return
        }

        entityViewModel.cancelLoadAlbumCover()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.collectionView(collectionView, didSelectLocationItemAt: indexPath)
        }
        self.collectionView(collectionView, didSelectEntityItemAt: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectLocationItemAt indexPath: IndexPath) {
        guard
            let locationName = viewModel.locationName,
            let mapReference = viewModel.mapReference
            else {
                return
        }

        let rl = ResourceLocator.createAppleMapsResourceLocator(appleMapsLocationName: locationName, appleMapsLatitude: mapReference.latitude, appleMapsLongitude: mapReference.longitude)
        _ = forwardNavigationContext.navigate(with: rl, from: self, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectEntityItemAt indexPath: IndexPath) {
        guard
            let entityViewModel = viewModel.eventEntityViewModel(at: indexPath.row),
            let spotifyURL = entityViewModel.spotifyURL
            else {
                return
        }

        let rl = ResourceLocator.createSpotifyResourceLocator(spotifyURL: spotifyURL)
        _ = forwardNavigationContext.navigate(with: rl, from: self, animated: true)
    }
}
