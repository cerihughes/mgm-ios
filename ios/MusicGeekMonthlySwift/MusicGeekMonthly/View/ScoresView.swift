import UIKit

/// A view that represents a list of albums and their scores
class ScoresView: UIView {
    let collectionView: UICollectionView
    let searchBar = UISearchBar()
    private let messageView = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

    override init(frame: CGRect) {
        let layout = ScoresCollectionViewLayout(itemHeight: 64.0, spacing: 4.0)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .black

        super.init(frame: frame)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.accessibilityIdentifier = "mgm:scores:collectionView"

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Filter"

        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.isHidden = true
        messageView.numberOfLines = 0
        messageView.textAlignment = .center
        messageView.accessibilityIdentifier = "mgm:scores:messageView"

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.accessibilityIdentifier = "mgm:scores:activityView"

        addSubview(collectionView)
        addSubview(searchBar)
        addSubview(messageView)
        addSubview(activityIndicatorView)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: messageView.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                            trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                            centerXAnchor: safeAreaLayoutGuide.centerXAnchor,
                                                            centerYAnchor: safeAreaLayoutGuide.centerYAnchor))

        constraints.append(contentsOf: searchBar.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                          trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                          topAnchor: safeAreaLayoutGuide.topAnchor))

        constraints.append(contentsOf: collectionView.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                               trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                               topAnchor: searchBar.bottomAnchor,
                                                               bottomAnchor: safeAreaLayoutGuide.bottomAnchor))

        constraints.append(contentsOf: activityIndicatorView.anchorTo(centerXAnchor: safeAreaLayoutGuide.centerXAnchor,
                                                                      centerYAnchor: safeAreaLayoutGuide.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showTableView() {
        messageView.isHidden = true
        collectionView.isHidden = false
    }

    func showMessage(_ message: String) {
        messageView.text = message
        messageView.isHidden = false
        collectionView.isHidden = true
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
