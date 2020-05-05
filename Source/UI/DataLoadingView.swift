import SnapKit
import UIKit

/// An abstract view that contains a loading indicator and message view
class DataLoadingView: UIView {
    private let messageView = UILabel()
    let retryButton = UIButton(type: .system)
    private let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    private let spacing: CGFloat = 32.0

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

        messageView.isHidden = true
        messageView.numberOfLines = 0
        messageView.textAlignment = .center
        messageView.accessibilityIdentifier = "mgm:view:messageView"

        retryButton.accessibilityIdentifier = "mgm:view:retryButton"
        retryButton.isHidden = true

        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.accessibilityIdentifier = "mgm:view:activityView"

        addSubview(messageView)
        addSubview(retryButton)
        addSubview(activityIndicatorView)

        messageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        retryButton.snp.makeConstraints { make in
            make.bottom.equalTo(messageView).inset(spacing)
            make.centerX.equalTo(messageView)
        }

        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
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
