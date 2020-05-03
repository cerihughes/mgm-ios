import SnapKit
import UIKit

class LatestEventEntityCollectionViewCell: AlbumCollectionViewCell {
    let typeLabel = UILabel()
    let albumLabel = UILabel()
    private let byLabel = UILabel()
    let artistLabel = UILabel()

    private let spacing: CGFloat = 16.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true

        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        backgroundImageView.addSubview(blurView)

        backgroundView = backgroundImageView

        typeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        typeLabel.textColor = .black
        typeLabel.textAlignment = .center

        albumLabel.font = UIFont.systemFont(ofSize: 14)
        albumLabel.textColor = .black
        albumLabel.textAlignment = .center

        byLabel.font = UIFont.italicSystemFont(ofSize: 12)
        byLabel.textColor = .black
        byLabel.textAlignment = .center
        byLabel.text = "by"

        artistLabel.font = UIFont.systemFont(ofSize: 14)
        artistLabel.textColor = .black
        artistLabel.textAlignment = .center

        contentView.addSubview(typeLabel)
        contentView.addSubview(albumLabel)
        contentView.addSubview(byLabel)
        contentView.addSubview(artistLabel)

        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundImageView)
        }

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.readableContentGuide).inset(spacing)
            make.top.bottom.equalTo(contentView).inset(spacing)
            make.width.equalTo(imageView.snp.height)
        }

        let halfSpacing = spacing / 2.0
        apply(borderSpacing: halfSpacing)

        typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(spacing + halfSpacing)
            make.trailing.equalTo(contentView.readableContentGuide).inset(spacing)
            make.top.equalTo(contentView).offset(spacing)
            make.bottom.equalTo(albumLabel.snp.top).inset(-spacing)
        }

        albumLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(typeLabel)
            make.bottom.equalTo(byLabel.snp.top).inset(-halfSpacing)
            make.height.equalTo(typeLabel).multipliedBy(0.75)
        }

        byLabel.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(albumLabel)
            make.bottom.equalTo(artistLabel.snp.top).inset(-halfSpacing)
        }

        artistLabel.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(albumLabel)
            make.bottom.equalTo(contentView).inset(spacing)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        albumLabel.text = nil
        artistLabel.text = nil
    }
}
