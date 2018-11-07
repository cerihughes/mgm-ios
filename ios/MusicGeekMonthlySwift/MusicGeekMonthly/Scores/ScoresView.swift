import UIKit

/// A view that represents a list of albums and their scores
class ScoresView: DataLoadingView {
    let collectionView: UICollectionView
    let searchBar = UISearchBar()

    override init(frame: CGRect) {
        let layout = FullWidthCollectionViewLayout(itemHeight: 64.0, spacing: 1.0)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.isHidden = true
        collectionView.accessibilityIdentifier = "mgm:scores:collectionView"

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.showsCancelButton = true

        addSubview(collectionView)
        addSubview(searchBar)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: searchBar.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                          trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                          topAnchor: safeAreaLayoutGuide.topAnchor))

        constraints.append(contentsOf: collectionView.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                               trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                               topAnchor: searchBar.bottomAnchor,
                                                               bottomAnchor: safeAreaLayoutGuide.bottomAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
