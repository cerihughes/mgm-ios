import UserNotifications

enum LocalNotificationType {
    case newEvent(Event)
    case scoresPublished(Event)
    case eventScheduled(Event)
    case eventCancelled(Event)
}

protocol LocalNotificationsManager {
    func isAuthorized(completion: @escaping (Bool) -> Void)
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleLocalNotification(type: LocalNotificationType,
                                   completion: @escaping (Bool) -> Void)
}

class LocalNotificationsManagerImplementation: NSObject, LocalNotificationsManager {
    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter) {
        self.notificationCenter = notificationCenter

        super.init()

        notificationCenter.delegate = self
    }

    func isAuthorized(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            let isAuthorized = settings.authorizationStatus == .authorized && settings.alertSetting == .enabled
            completion(isAuthorized)
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert]
        notificationCenter.requestAuthorization(options: options) { didAllow, _ in
            completion(didAllow)
        }
    }

    func scheduleLocalNotification(type: LocalNotificationType,
                                   completion: @escaping (Bool) -> Void) {
        let identifier = type.identifier
        let content = UNMutableNotificationContent()
        content.title = type.title
        content.body = type.body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            completion(error == nil)
        }
    }
}

extension LocalNotificationsManagerImplementation: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

private extension LocalNotificationType {
    var identifier: String {
        switch self {
        case let .newEvent(event):
            return "newEvent\(event.number)"
        case let .scoresPublished(event):
            return "scoresPublished\(event.number)"
        case let .eventScheduled(event):
            return "eventScheduled\(event.number)"
        case let .eventCancelled(event):
            return "eventCancelled\(event.number)"
        }
    }

    var title: String {
        switch self {
        case let .newEvent(event):
            return "New Event - MGM \(event.number)"
        case let .scoresPublished(event):
            return "Scores Published - MGM \(event.number)"
        case let .eventScheduled(event):
            return "Event Scheduled - MGM \(event.number)"
        case let .eventCancelled(event):
            return "Event Cancelled - MGM \(event.number)"
        }
    }

    var body: String {
        switch self {
        case .newEvent:
            return "Next month's albums have been published. Tap to check them out..."
        case .scoresPublished:
            return "The scores are in for last month's albums. Tap to check them out..."
        case .eventScheduled:
            return "This month's event has been scheduled"
        case .eventCancelled:
            return "A new event has been published"
        }
    }
}
