import SnapKit
import UIKit

class LabelWithSwitch: UIView {
    let labelView = UILabel()
    let switchView = UISwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(labelView)
        addSubview(switchView)

        labelView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(switchView.snp.leading)
        }

        switchView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(labelView)
        }
    }
}
