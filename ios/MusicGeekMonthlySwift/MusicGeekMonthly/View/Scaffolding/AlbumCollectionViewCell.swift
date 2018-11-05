import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    private let borderView = UIView()
    let imageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .black

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true

        addSubview(borderView)
        addSubview(imageView)
        addSubview(activityIndicatorView)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: activityIndicatorView.anchorTo(centerXAnchor: imageView.centerXAnchor,
                                                                      centerYAnchor: imageView.centerYAnchor))

        constraints.append(contentsOf: borderView.anchorTo(centerXAnchor: imageView.centerXAnchor,
                                                           centerYAnchor: imageView.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil

        hideActivityIndicator()
    }

    // MARK: API

    func apply(borderSpacing: CGFloat) {
        var constraints: [NSLayoutConstraint] = []

        let constant = 2.0 * borderSpacing
        constraints.append(contentsOf: borderView.anchorTo(widthAnchor: imageView.widthAnchor, widthConstant: constant,
                                                           heightAnchor: imageView.heightAnchor, heightConstant: constant))

        NSLayoutConstraint.activate(constraints)
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
