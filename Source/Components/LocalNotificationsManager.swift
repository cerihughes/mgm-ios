import UserNotifications

protocol LocalNotificationsManager {
    func isAuthorized(completion: @escaping (Bool) -> Void)
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleLocalNotification(eventUpdate: EventUpdate)
}

extension LocalNotificationsManager {
    func scheduleLocalNotifications(eventUpdates: [EventUpdate]) {
        eventUpdates.forEach { scheduleLocalNotification(eventUpdate: $0) }
    }
}

private extension Array {
    func removedFirst() -> Array? {
        guard first != nil else {
            return nil
        }
        var array = self
        array.removeFirst()
        return array
    }
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

    func scheduleLocalNotification(eventUpdate: EventUpdate) {
        guard let body = eventUpdate.body else {
            return
        }

        let identifier = eventUpdate.identifier
        let content = UNMutableNotificationContent()
        content.title = eventUpdate.title
        content.body = body

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)

        notificationCenter.add(request, withCompletionHandler: nil)
    }
}

extension LocalNotificationsManagerImplementation: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}

private extension EventUpdate {
    var identifier: String {
        switch self {
        case let .newEvent(event):
            return "newEvent\(event.number)"
        case let .scoresPublished(event):
            return "scoresPublished\(event.number)"
        case let .eventScheduled(event):
            return "eventScheduled\(event.number)"
        case let .eventRescheduled(event):
            return "eventRescheduled\(event.number)"
        case let .eventCancelled(event):
            return "eventCancelled\(event.number)"
        case let .playlistPublished(event):
            return "playlistPublished\(event.number)"
        }
    }

    var title: String {
        switch self {
        case let .newEvent(event):
            return "New Event - MGM \(event.number)"
        case let .scoresPublished(event):
            return "Scores Available - MGM \(event.number)"
        case let .eventScheduled(event):
            return "Event Scheduled - MGM \(event.number)"
        case let .eventRescheduled(event):
            return "Event Rescheduled - MGM \(event.number)"
        case let .eventCancelled(event):
            return "Event Cancelled - MGM \(event.number)"
        case let .playlistPublished(event):
            return "Playlist Available - MGM \(event.number)"
        }
    }

    var body: String? {
        switch self {
        case .newEvent:
            return "Next month's albums are now available."
        case .scoresPublished:
            return "The scores are in for last month's albums."
        case let .eventScheduled(event):
            guard let dateString = event.dateString else {
                return nil
            }
            return "This month's event has been scheduled for \(dateString)"
        case let .eventRescheduled(event):
            guard let dateString = event.dateString else {
                return nil
            }
            return "This month's event has been rescheduled for \(dateString)"
        case .eventCancelled:
            return "This month's event has been cancelled. Check the Facebook group for more details."
        case .playlistPublished:
            return "This month's playlist is now available."
        }
    }
}

private extension Event {
    var dateString: String? {
        guard let date = date else {
            return nil
        }

        let formatter = DateFormatter.mgm_latestEventDateFormatter()
        return formatter.string(from: date)
    }
}
