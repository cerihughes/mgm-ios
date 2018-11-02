import UIKit

class ScoresCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    let albumLabel = UILabel()
    let artistLabel = UILabel()

    private let spacing: CGFloat = 8.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(activityIndicatorView)
        addSubview(albumLabel)
        addSubview(artistLabel)

        var constraints: [NSLayoutConstraint] = []

        constraints.append(contentsOf: imageView.anchorTo(leadingAnchor: leadingAnchor, leadingConstant: spacing,
                                                          topAnchor: topAnchor, topConstant: spacing,
                                                          bottomAnchor: bottomAnchor, bottomConstant: spacing,
                                                          widthAnchor: imageView.heightAnchor));

        NSLayoutConstraint.activate(constraints)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
