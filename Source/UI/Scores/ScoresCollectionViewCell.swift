import UIKit

class ScoresCollectionViewCell: AlbumCollectionViewCell {
    let albumLabel = UILabel.createCollectionViewLabel(font: .systemFont(ofSize: 14), alignment: .natural)
    let artistLabel = UILabel.createCollectionViewLabel(font: .italicSystemFont(ofSize: 14), alignment: .natural)
    let awardImageView = UIImageView()
    let ratingLabel = UILabel.createCollectionViewLabel(font: .boldSystemFont(ofSize: 19), alignment: .natural)
    let positionLabel = UILabel.createCollectionViewLabel(font: .boldSystemFont(ofSize: 14))

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
        awardImageView.contentMode = .scaleAspectFit

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
