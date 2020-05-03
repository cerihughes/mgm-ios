import SnapKit
import UIKit

/// A view that represents a list of albums and their scores
class ScoresView: DataLoadingView {
    let collectionView = FullWidthCollectionViewLayout(itemHeight: 64.0, spacing: 1.0).createCollectionView()
    let searchBar = UISearchBar()

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
        collectionView.accessibilityIdentifier = "mgm:scores:collectionView"

        searchBar.showsCancelButton = true

        addSubview(collectionView)
        addSubview(searchBar)

        searchBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    func showResults() {
        hideMessage()
        collectionView.isHidden = false
    }

    override func showMessage(_ message: String, showRetryButton: Bool) {
        super.showMessage(message, showRetryButton: showRetryButton)
        collectionView.isHidden = true
    }
}
