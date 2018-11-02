import UIKit

class ScoresCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let albumLabel = UILabel()
    let artistLabel = UILabel()

    private let spacing: CGFloat = 4.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .darkGray

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true

        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.font = UIFont.systemFont(ofSize: 14)

        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.font = UIFont.italicSystemFont(ofSize: 14)

        addSubview(imageView)
        addSubview(activityIndicatorView)
        addSubview(albumLabel)
        addSubview(artistLabel)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: albumLabel.anchorTo(leadingAnchor: imageView.trailingAnchor, leadingConstant: spacing,
                                                           trailingAnchor: trailingAnchor, trailingConstant: -spacing,
                                                            topAnchor: topAnchor, topConstant: spacing,
                                                            bottomAnchor: artistLabel.topAnchor, bottomConstant: -spacing));

        constraints.append(contentsOf: artistLabel.anchorTo(leadingAnchor: imageView.trailingAnchor, leadingConstant: spacing,
                                                            trailingAnchor: trailingAnchor, trailingConstant: -spacing,
                                                            bottomAnchor: bottomAnchor, bottomConstant: -spacing,
                                                            heightAnchor: albumLabel.heightAnchor));

        constraints.append(contentsOf: imageView.anchorTo(leadingAnchor: leadingAnchor, leadingConstant: spacing,
                                                          topAnchor: topAnchor, topConstant: spacing,
                                                          bottomAnchor: bottomAnchor, bottomConstant: -spacing,
                                                          widthAnchor: imageView.heightAnchor));

        constraints.append(contentsOf: activityIndicatorView.anchorTo(centerXAnchor: imageView.centerXAnchor,
                                                                      centerYAnchor: imageView.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}
