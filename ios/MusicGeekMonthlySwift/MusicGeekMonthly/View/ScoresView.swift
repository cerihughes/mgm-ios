import UIKit

/// A view that represents a list of albums and their scores
class ScoresView: UIView {
    let tableView = UITableView()
    let searchBar = UISearchBar()
    private let messageView = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGray

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.accessibilityIdentifier = "mgm:scores:tableView"

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

        addSubview(tableView)
        addSubview(searchBar)
        addSubview(messageView)
        addSubview(activityIndicatorView)

        let messageViewCenterX = messageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        let messageViewCenterY = messageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        let messageViewLeading = messageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let messageViewTrailing = messageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)

        let searchBarLeading = searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let searchBarTrailing = searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let searchBarTop = searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)

        let tableViewLeading = tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let tableViewTrailing = tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let tableViewTop = tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        let tableViewBottom = tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)

        let activityIndicatorViewCenterX = activityIndicatorView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        let activityIndicatorViewCenterY = activityIndicatorView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)

        NSLayoutConstraint.activate([messageViewCenterX, messageViewCenterY, messageViewLeading, messageViewTrailing,
                                     searchBarLeading, searchBarTrailing, searchBarTop,
                                     tableViewLeading, tableViewTrailing, tableViewTop, tableViewBottom,
                                     activityIndicatorViewCenterX, activityIndicatorViewCenterY])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showTableView() {
        messageView.isHidden = true
        tableView.isHidden = false
    }

    func showMessage(_ message: String) {
        messageView.text = message
        messageView.isHidden = false
        tableView.isHidden = true
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
