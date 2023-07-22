import CoreLocation
import Madog
import UIKit

private let sectionHeaderReuseIdentifier = "LatestEventViewController_CellReuseIdentifier_SectionHeader"
private let locationCellReuseIdentifier = "LatestEventViewController_CellReuseIdentifier_Location"
private let entityCellReuseIdentifier = "LatestEventViewController_CellReuseIdentifier_Enity"

class LatestEventViewController: ForwardNavigatingViewController {
    private var viewModel: LatestEventViewModel
    private let latestEventView = LatestEventView()

    init(navigationContext: AnyForwardBackNavigationContext<Navigation>, viewModel: LatestEventViewModel) {
        self.viewModel = viewModel

        super.init(navigationContext: navigationContext)
    }

    override func loadView() {
        view = latestEventView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = viewModel.title

        latestEventView.collectionView.register(
            LatestEventCollectionSectionHeaderView.self,
            forSupplementaryViewOfKind: FullWidthCollectionViewLayout.Element.sectionHeader
                .value,
            withReuseIdentifier: sectionHeaderReuseIdentifier
        )
        latestEventView.collectionView.register(
            LatestEventLocationCollectionViewCell.self,
            forCellWithReuseIdentifier: locationCellReuseIdentifier
        )
        latestEventView.collectionView.register(
            LatestEventEntityCollectionViewCell.self,
            forCellWithReuseIdentifier: entityCellReuseIdentifier
        )
        latestEventView.collectionView.dataSource = self
        latestEventView.collectionView.delegate = self

        latestEventView.retryButton.setTitle(viewModel.retryButtonTitle, for: .normal)
        latestEventView.retryButton.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)

        loadData()
    }

    // MARK: Private

    private func loadData() {
        latestEventView.hideMessage()
        latestEventView.showActivityIndicator()
        viewModel.loadData { [weak self] in
            self?.latestEventView.hideActivityIndicator()
            self?.updateUI()
        }
    }

    private func updateUI() {
        navigationItem.title = viewModel.title

        if let message = viewModel.message {
            latestEventView.showMessage(message, showRetryButton: true)
        } else {
            latestEventView.showResults()
            latestEventView.collectionView.reloadData()
        }
    }
}

extension LatestEventViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: UICollectionViewDataSource

    func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.isLocationAvailable ? 1 : 0
        case 1:
            return viewModel.numberOfEntites
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: sectionHeaderReuseIdentifier,
            for: indexPath
        )
        guard
            let headerView = view as? LatestEventCollectionSectionHeaderView,
            let headerTitle = viewModel.headerTitle(for: indexPath.section)
        else {
            return view
        }

        headerView.label.text = headerTitle

        return headerView
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return self.collectionView(collectionView, locationCellForItemAt: indexPath)
        }
        return self.collectionView(collectionView, entityCellForItemAt: indexPath)
    }

    private func collectionView(
        _ collectionView: UICollectionView,
        locationCellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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

    private func collectionView(
        _ collectionView: UICollectionView,
        entityCellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: entityCellReuseIdentifier, for: indexPath)
        guard
            let entityCell = cell as? LatestEventEntityCollectionViewCell,
            let viewData = viewModel.eventEntityViewData(at: indexPath.row)
        else {
            return cell
        }

        entityCell.typeLabel.text = viewData.entityType
        entityCell.albumLabel.text = viewData.entityName
        entityCell.artistLabel.text = viewData.entityOwner

        return entityCell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard
            indexPath.section == 1,
            let entityCell = cell as? LatestEventEntityCollectionViewCell,
            let backgroundImageView = entityCell.backgroundView as? UIImageView,
            let viewData = viewModel.eventEntityViewData(at: indexPath.row),
            let layout = collectionView.collectionViewLayout as? FullWidthCollectionViewLayout
        else {
            return
        }

        entityCell.imageView.image = viewData.loadingImage
        backgroundImageView.image = viewData.loadingImage

        entityCell.showActivityIndicator()

        let contentViewHeight = layout.contentViewSize(in: indexPath.section).height
        let largestDimension = Int(contentViewHeight * collectionView.traitCollection.displayScale)

        viewModel.loadAlbumCover(largestDimension: largestDimension, viewData: viewData) { image in
            entityCell.hideActivityIndicator()
            if let image {
                backgroundImageView.image = image
                entityCell.imageView.image = image
            }
        }
    }

    func collectionView(_: UICollectionView, didEndDisplaying _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            indexPath.section == 1,
            let viewData = viewModel.eventEntityViewData(at: indexPath.row)
        else {
            return
        }

        viewModel.cancelLoadAlbumCover(viewData: viewData)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.collectionView(collectionView, didSelectLocationItemAt: indexPath)
        } else {
            self.collectionView(collectionView, didSelectEntityItemAt: indexPath)
        }
    }

    func collectionView(_: UICollectionView, didSelectLocationItemAt _: IndexPath) {
        guard
            let locationName = viewModel.locationName,
            let mapReference = viewModel.mapReference
        else {
            return
        }

        let rl = Navigation.appleMaps(
            locationName: locationName,
            latitude: mapReference.latitude,
            longitude: mapReference.longitude
        )
        navigationContext?.navigateForward(token: rl, animated: true)
    }

    func collectionView(_: UICollectionView, didSelectEntityItemAt indexPath: IndexPath) {
        guard
            let viewData = viewModel.eventEntityViewData(at: indexPath.row),
            let spotifyURL = viewData.spotifyURL
        else {
            return
        }

        let rl = Navigation.spotify(spotifyURL: spotifyURL)
        navigationContext?.navigateForward(token: rl, animated: true)
    }
}

extension LatestEventViewController {
    // MARK: UIButton interactions

    @objc
    private func buttonTapGesture(sender _: UIButton) {
        loadData()
    }
}
