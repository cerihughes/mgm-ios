import UIKit

class LatestEventCollectionViewCell: AlbumCollectionViewCell {
    let typeLabel = UILabel()
    let albumLabel = UILabel()
    let artistLabel = UILabel()

    private let spacing: CGFloat = 16.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        typeLabel.textColor = .black

        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.font = UIFont.systemFont(ofSize: 14)
        albumLabel.textColor = .black

        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.font = UIFont.italicSystemFont(ofSize: 14)
        artistLabel.textColor = .black

        addSubview(typeLabel)
        addSubview(albumLabel)
        addSubview(artistLabel)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: imageView.anchorTo(leadingAnchor: leadingAnchor, leadingConstant: spacing,
                                                          topAnchor: topAnchor, topConstant: spacing,
                                                          bottomAnchor: bottomAnchor, bottomConstant: -spacing,
                                                          widthAnchor: imageView.heightAnchor))

        let borderSpacing = spacing / 2.0
        apply(borderSpacing: borderSpacing)

        constraints.append(contentsOf: typeLabel.anchorTo(leadingAnchor: imageView.trailingAnchor, leadingConstant: spacing + borderSpacing,
                                                          trailingAnchor: trailingAnchor, trailingConstant: -spacing,
                                                          topAnchor: topAnchor, topConstant: spacing,
                                                          bottomAnchor: albumLabel.topAnchor, bottomConstant: -spacing))

        constraints.append(contentsOf: albumLabel.anchorTo(leadingAnchor: typeLabel.leadingAnchor,
                                                           trailingAnchor: typeLabel.trailingAnchor,
                                                           bottomAnchor: artistLabel.topAnchor, bottomConstant: -spacing,
                                                           heightAnchor: typeLabel.heightAnchor))

        constraints.append(contentsOf: artistLabel.anchorTo(leadingAnchor: typeLabel.leadingAnchor,
                                                            trailingAnchor: typeLabel.trailingAnchor,
                                                            bottomAnchor: bottomAnchor, bottomConstant: -spacing,
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
