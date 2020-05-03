import SnapKit
import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    private let borderView = UIView()
    let imageView = UIImageView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commontInit()
    }

    private func commontInit() {
        backgroundColor = .white

        borderView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        activityIndicatorView.hidesWhenStopped = true

        contentView.addSubview(borderView)
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicatorView)

        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil

        hideActivityIndicator()
    }

    // MARK: API

    func apply(borderSpacing: CGFloat) {
        borderView.snp.makeConstraints { make in
            make.edges.equalTo(imageView).inset(-borderSpacing)
        }
    }

    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}

extension UILabel {
    static func createCollectionViewLabel(font: UIFont, color: UIColor = .black, alignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        return label
    }
}
