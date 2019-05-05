import UIKit

class LatestEventEntityCollectionViewCell: AlbumCollectionViewCell {
    let typeLabel = UILabel()
    let albumLabel = UILabel()
    private let byLabel = UILabel()
    let artistLabel = UILabel()

    private let spacing: CGFloat = 16.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        let backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.addSubview(blurView)

        backgroundView = backgroundImageView

        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        typeLabel.textColor = .black
        typeLabel.textAlignment = .center

        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.font = UIFont.systemFont(ofSize: 14)
        albumLabel.textColor = .black
        albumLabel.textAlignment = .center

        byLabel.translatesAutoresizingMaskIntoConstraints = false
        byLabel.font = UIFont.italicSystemFont(ofSize: 12)
        byLabel.textColor = .black
        byLabel.textAlignment = .center
        byLabel.text = "by"

        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.font = UIFont.systemFont(ofSize: 14)
        artistLabel.textColor = .black
        artistLabel.textAlignment = .center

        contentView.addSubview(typeLabel)
        contentView.addSubview(albumLabel)
        contentView.addSubview(byLabel)
        contentView.addSubview(artistLabel)

        let readableLeadingAnchor = contentView.readableContentGuide.leadingAnchor
        let readableTrailingAnchor = contentView.readableContentGuide.trailingAnchor

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: backgroundImageView.anchorTo(view: self))
        constraints.append(contentsOf: blurView.anchorTo(view: backgroundImageView))

        constraints.append(contentsOf: imageView.anchorTo(leadingAnchor: readableLeadingAnchor, leadingConstant: spacing,
                                                          topAnchor: contentView.topAnchor, topConstant: spacing,
                                                          bottomAnchor: contentView.bottomAnchor, bottomConstant: -spacing,
                                                          widthAnchor: imageView.heightAnchor))

        let halfSpacing = spacing / 2.0
        apply(borderSpacing: halfSpacing)

        constraints.append(contentsOf: typeLabel.anchorTo(leadingAnchor: imageView.trailingAnchor, leadingConstant: spacing + halfSpacing,
                                                          trailingAnchor: readableTrailingAnchor, trailingConstant: -spacing,
                                                          topAnchor: contentView.topAnchor, topConstant: spacing,
                                                          bottomAnchor: albumLabel.topAnchor, bottomConstant: -spacing))

        constraints.append(contentsOf: albumLabel.anchorTo(leadingAnchor: typeLabel.leadingAnchor,
                                                           trailingAnchor: typeLabel.trailingAnchor,
                                                           bottomAnchor: byLabel.topAnchor, bottomConstant: -halfSpacing,
                                                           heightAnchor: typeLabel.heightAnchor, heightMultiplier: 0.75))

        constraints.append(contentsOf: byLabel.anchorTo(leadingAnchor: albumLabel.leadingAnchor,
                                                        trailingAnchor: albumLabel.trailingAnchor,
                                                        bottomAnchor: artistLabel.topAnchor, bottomConstant: -halfSpacing,
                                                        heightAnchor: albumLabel.heightAnchor));

        constraints.append(contentsOf: artistLabel.anchorTo(leadingAnchor: albumLabel.leadingAnchor,
                                                            trailingAnchor: albumLabel.trailingAnchor,
                                                            bottomAnchor: contentView.bottomAnchor, bottomConstant: -spacing,
                                                            heightAnchor: albumLabel.heightAnchor));

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        albumLabel.text = nil
        artistLabel.text = nil
    }
}
