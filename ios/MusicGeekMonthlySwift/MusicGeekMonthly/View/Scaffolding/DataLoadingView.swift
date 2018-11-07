import UIKit

/// An abstract view that contains a loading indicator and message view
class DataLoadingView: UIView {
    private let messageView = UILabel()
    let retryButton = UIButton(type: .system)
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    private let spacing: CGFloat = 32.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.isHidden = true
        messageView.numberOfLines = 0
        messageView.textAlignment = .center
        messageView.accessibilityIdentifier = "mgm:view:messageView"

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.accessibilityIdentifier = "mgm:view:retryButton"
        retryButton.isHidden = true

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.accessibilityIdentifier = "mgm:view:activityView"

        addSubview(messageView)
        addSubview(retryButton)
        addSubview(activityIndicatorView)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: messageView.anchorTo(layoutGuide: safeAreaLayoutGuide))

        constraints.append(contentsOf: retryButton.anchorTo(bottomAnchor: messageView.bottomAnchor, bottomConstant: -spacing,
                                                            centerXAnchor: messageView.centerXAnchor))

        constraints.append(contentsOf: activityIndicatorView.anchorTo(centerXAnchor: safeAreaLayoutGuide.centerXAnchor,
                                                                      centerYAnchor: safeAreaLayoutGuide.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hideMessage() {
        messageView.isHidden = true
        retryButton.isHidden = true
    }

    func showMessage(_ message: String, showRetryButton: Bool) {
        messageView.text = message
        messageView.isHidden = false
        retryButton.isHidden = !showRetryButton
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
