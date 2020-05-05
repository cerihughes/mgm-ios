import SnapKit
import UIKit

class LatestEventCollectionSectionHeaderView: UICollectionReusableView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func commonInit() {
        backgroundColor = .white

        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center

        addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
