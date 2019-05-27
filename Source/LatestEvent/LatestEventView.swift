import UIKit

/// A view that represents the latest event, and the albums being reviewed
class LatestEventView: DataLoadingView {
    let collectionView: UICollectionView

    override init(frame: CGRect) {
        let layout = FullWidthCollectionViewLayout(sectionHeaderHeight: 32.0, defaultItemHeight: 128.0, itemHeightOverrides:[0 : 192.0], spacing: 4.0)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.isHidden = true
        collectionView.accessibilityIdentifier = "mgm:latestEvent:collectionView"

        addSubview(collectionView)

        let constraints: [NSLayoutConstraint] = collectionView.anchorTo(layoutGuide: safeAreaLayoutGuide)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: API

    func showResults() {
        hideMessage()
        collectionView.isHidden = false
    }

    override func showMessage(_ message: String, showRetryButton: Bool) {
        super.showMessage(message, showRetryButton: showRetryButton)
        collectionView.isHidden = true
    }
}
