import UIKit

class SettingsViewController: UIViewController {
    private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = SettingsView()
    }

    override func viewDidLoad() {
        title = viewModel.title

        guard let settingsView = settingsView else { return }

        settingsView.localNotifications.title.text = viewModel.localNotificationsTitle
        settingsView.localNotifications.subtitle.text = viewModel.localNotificationsSubtitle
        settingsView.localNotifications.toggle.addTarget(self, action: #selector(toggled(sender:)), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getLocalNotificationsState { [weak self] state in
            guard let settingsView = self?.settingsView else { return }
            settingsView.localNotifications.toggle.isOn = state
        }
    }

    private var settingsView: SettingsView? {
        view as? SettingsView
    }

    @objc
    private func toggled(sender: UISwitch) {
        viewModel.updateLocalNotificationsState(sender.isOn) { [weak self] state in
            switch state {
            case let .updated(value):
                sender.isOn = value
            case .updateDenied:
                sender.isOn = false
            case .alreadyDenied:
                sender.isOn = false
                self?.showSettingsAlert()
            }
        }
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(title: viewModel.localNotificationsDisabledTitle,
                                      message: viewModel.localNotificationsDisabledMessage,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
