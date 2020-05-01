import UIKit

class SettingsViewController: UIViewController {
    private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SettingsView()
    }

    override func viewDidLoad() {
        title = viewModel.title

        guard let settingsView = view as? SettingsView else { return }

        settingsView.localNotifications.title.text = viewModel.localNotificationsTitle
        settingsView.localNotifications.subtitle.text = viewModel.localNotificationsSubtitle
    }
}
