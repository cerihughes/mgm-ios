import SnapKit
import UIKit

class LabelWithSwitch: UIView {
    let title = UILabel()
    let subtitle = UILabel()
    let toggle = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.numberOfLines = 1
        subtitle.font = UIFont.italicSystemFont(ofSize: 12)
        subtitle.numberOfLines = 0

        addSubview(title)
        addSubview(subtitle)
        addSubview(toggle)

        title.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.bottom.equalTo(subtitle.snp.top)
            make.trailing.equalTo(toggle.snp.leading)
        }

        toggle.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview()
            make.bottom.equalTo(subtitle.snp.top)
            make.height.equalTo(title)
        }

        subtitle.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
