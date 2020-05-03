import UIKit

class ScoresCollectionViewCell: AlbumCollectionViewCell {
    let albumLabel = UILabel()
    let artistLabel = UILabel()
    let awardImageView = UIImageView()
    let ratingLabel = UILabel()
    let positionLabel = UILabel()

    private let spacing: CGFloat = 4.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        albumLabel.font = UIFont.systemFont(ofSize: 14)
        albumLabel.textColor = .black

        artistLabel.font = UIFont.italicSystemFont(ofSize: 14)
        artistLabel.textColor = .black

        awardImageView.contentMode = .scaleAspectFit
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 19)

        positionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        positionLabel.textColor = .black
        positionLabel.textAlignment = .center

        contentView.addSubview(albumLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(awardImageView)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(positionLabel)

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.readableContentGuide).inset(spacing)
            make.top.bottom.equalTo(contentView).inset(spacing)
            make.width.equalTo(imageView.snp.height)
        }

        let borderSpacing = spacing / 2.0
        apply(borderSpacing: borderSpacing)

        albumLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(spacing + borderSpacing)
            make.trailing.equalTo(awardImageView.snp.leading).inset(-spacing)
            make.top.equalTo(contentView).offset(spacing)
            make.bottom.equalTo(artistLabel.snp.top).inset(-spacing)
        }

        artistLabel.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(albumLabel)
            make.bottom.equalTo(contentView).inset(spacing)
        }

        awardImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.readableContentGuide).inset(spacing)
            make.top.bottom.equalTo(contentView).inset(spacing)
            make.width.equalTo(awardImageView.snp.height)
        }

        ratingLabel.snp.makeConstraints { make in
            make.center.equalTo(awardImageView)
        }

        positionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(spacing)
            make.centerX.equalTo(awardImageView)
            make.height.equalTo(awardImageView).multipliedBy(0.333)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        albumLabel.text = nil
        artistLabel.text = nil
        awardImageView.image = nil
        ratingLabel.text = nil
        ratingLabel.textColor = .black
        positionLabel.text = nil
    }
}
