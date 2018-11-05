import UIKit

/// An abstract view that contains a loading indicator and message view
class DataLoadingView: UIView {
    private let messageView = UILabel()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.isHidden = true
        messageView.numberOfLines = 0
        messageView.textAlignment = .center
        messageView.accessibilityIdentifier = "mgm:view:messageView"

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.accessibilityIdentifier = "mgm:view:activityView"

        addSubview(messageView)
        addSubview(activityIndicatorView)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: messageView.anchorTo(leadingAnchor: safeAreaLayoutGuide.leadingAnchor,
                                                            trailingAnchor: safeAreaLayoutGuide.trailingAnchor,
                                                            centerXAnchor: safeAreaLayoutGuide.centerXAnchor,
                                                            centerYAnchor: safeAreaLayoutGuide.centerYAnchor))

        constraints.append(contentsOf: activityIndicatorView.anchorTo(centerXAnchor: safeAreaLayoutGuide.centerXAnchor,
                                                                      centerYAnchor: safeAreaLayoutGuide.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hideMessage() {
        messageView.isHidden = true
    }

    func showMessage(_ message: String) {
        messageView.text = message
        messageView.isHidden = false
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
