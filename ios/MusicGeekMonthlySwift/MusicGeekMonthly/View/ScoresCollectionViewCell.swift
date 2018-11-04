import UIKit

class ScoresCollectionViewCell: UICollectionViewCell {
    private let borderView = UIView()
    let imageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let albumLabel = UILabel()
    let artistLabel = UILabel()
    let awardImageView = UIImageView()
    let ratingLabel = UILabel()

    private let spacing: CGFloat = 4.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .black

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true

        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.font = UIFont.systemFont(ofSize: 14)
        albumLabel.textColor = .black

        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.font = UIFont.italicSystemFont(ofSize: 14)
        artistLabel.textColor = .black

        awardImageView.translatesAutoresizingMaskIntoConstraints = false

        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 19)
        ratingLabel.alpha = 0.75

        addSubview(borderView)
        addSubview(imageView)
        addSubview(activityIndicatorView)
        addSubview(albumLabel)
        addSubview(artistLabel)
        addSubview(awardImageView)
        addSubview(ratingLabel)

        var constraints: [NSLayoutConstraint] = []

        let halfSpacing = spacing / 2.0
        constraints.append(contentsOf: borderView.anchorTo(leadingAnchor: leadingAnchor, leadingConstant: halfSpacing,
                                                           topAnchor: topAnchor, topConstant: halfSpacing,
                                                           bottomAnchor: bottomAnchor, bottomConstant: -halfSpacing,
                                                           widthAnchor: borderView.heightAnchor))

        constraints.append(contentsOf: imageView.anchorTo(leadingAnchor: borderView.leadingAnchor, leadingConstant: halfSpacing,
                                                          trailingAnchor: borderView.trailingAnchor, trailingConstant: -halfSpacing,
                                                          topAnchor: borderView.topAnchor, topConstant: halfSpacing,
                                                          bottomAnchor: borderView.bottomAnchor, bottomConstant: -halfSpacing))

        constraints.append(contentsOf: albumLabel.anchorTo(leadingAnchor: borderView.trailingAnchor, leadingConstant: spacing,
                                                           trailingAnchor: awardImageView.leadingAnchor, trailingConstant: -spacing,
                                                           topAnchor: topAnchor, topConstant: spacing,
                                                           bottomAnchor: artistLabel.topAnchor, bottomConstant: -spacing))

        constraints.append(contentsOf: artistLabel.anchorTo(leadingAnchor: borderView.trailingAnchor, leadingConstant: spacing,
                                                            trailingAnchor: awardImageView.leadingAnchor, trailingConstant: -spacing,
                                                            bottomAnchor: bottomAnchor, bottomConstant: -spacing,
                                                            heightAnchor: albumLabel.heightAnchor));

        constraints.append(contentsOf: activityIndicatorView.anchorTo(centerXAnchor: imageView.centerXAnchor,
                                                                      centerYAnchor: imageView.centerYAnchor))

        constraints.append(contentsOf: awardImageView.anchorTo(trailingAnchor: trailingAnchor, trailingConstant: -spacing,
                                                               topAnchor: topAnchor, topConstant: spacing,
                                                               bottomAnchor: bottomAnchor, bottomConstant: -spacing,
                                                               widthAnchor: awardImageView.heightAnchor))

        constraints.append(contentsOf: ratingLabel.anchorTo(centerXAnchor: awardImageView.centerXAnchor,
                                                            centerYAnchor: awardImageView.centerYAnchor))

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        albumLabel.text = nil
        artistLabel.text = nil
        awardImageView.image = nil
        ratingLabel.text = nil
        ratingLabel.textColor = .black

        hideActivityIndicator()
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}

