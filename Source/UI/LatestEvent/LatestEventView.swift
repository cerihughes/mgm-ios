import SnapKit
import UIKit

/// A view that represents the latest event, and the albums being reviewed
class LatestEventView: DataLoadingView {
    let collectionView = FullWidthCollectionViewLayout(
        sectionHeaderHeight: 32.0,
        defaultItemHeight: 128.0,
        itemHeightOverrides: [0: 192.0],
        spacing: 4.0
    ).createCollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        collectionView.backgroundColor = .lightGray
        collectionView.isHidden = true
        collectionView.accessibilityIdentifier = "mgm:latestEvent:collectionView"

        addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
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
