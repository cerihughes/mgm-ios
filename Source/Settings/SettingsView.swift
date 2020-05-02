import SnapKit
import UIKit

class SettingsView: UIView {
    let localNotifications = LabelWithSwitch()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white

        localNotifications.accessibilityIdentifier = "mgm:settings:localNotifications"
        localNotifications.title.accessibilityIdentifier = "mgm:settings:localNotifications:label"
        localNotifications.toggle.accessibilityIdentifier = "mgm:settings:localNotifications:switch"

        addSubview(localNotifications)

        localNotifications.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
