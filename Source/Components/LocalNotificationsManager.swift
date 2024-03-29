import UserNotifications

enum AuthorizationStatus {
    case notDetermined, authorized, denied
}

protocol LocalNotificationsManager: AnyObject {
    var isEnabled: Bool { get set }
    func getAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void)
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleLocalNotification(eventUpdate: EventUpdate)
}

extension LocalNotificationsManager {
    func isAuthorized(completion: @escaping (Bool) -> Void) {
        getAuthorizationStatus { authorizationStatus in
            completion(authorizationStatus == .authorized)
        }
    }

    func scheduleLocalNotifications(eventUpdates: [EventUpdate]) {
        eventUpdates.forEach { scheduleLocalNotification(eventUpdate: $0) }
    }
}

class LocalNotificationsManagerImplementation: NSObject, LocalNotificationsManager {
    private let localDataSource: LocalDataSource
    private let notificationCenter: UNUserNotificationCenter

    init(localDataSource: LocalDataSource, notificationCenter: UNUserNotificationCenter) {
        self.localDataSource = localDataSource
        self.notificationCenter = notificationCenter

        super.init()

        notificationCenter.delegate = self
    }

    var isEnabled: Bool {
        get {
            localDataSource.localStorage.localNotificationsEnabled
        }
        set {
            localDataSource.localStorage.localNotificationsEnabled = newValue
        }
    }

    func getAuthorizationStatus(completion: @escaping (AuthorizationStatus) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus.mgmValue)
            }
        }
    }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert]
        notificationCenter.requestAuthorization(options: options) { didAllow, _ in
            DispatchQueue.main.async {
                completion(didAllow)
            }
        }
    }

    func scheduleLocalNotification(eventUpdate: EventUpdate) {
        guard isEnabled == true, let body = eventUpdate.body else {
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
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
            -> Void
    ) {
        completionHandler(.alert)
    }
}

private extension UNAuthorizationStatus {
    var mgmValue: AuthorizationStatus {
        switch self {
        case .notDetermined:
            return .notDetermined
        case .authorized, .provisional:
            return .authorized
        case .denied:
            return .denied
        @unknown default:
            return .denied
        }
    }
}

extension EventUpdate {
    var identifier: String {
        switch self {
        case let .newEvent(event):
            return "newEvent\(event.number)"
        case let .scoresPublished(album):
            return "scoresPublished\(album.uniqueID)"
        case let .eventScheduled(event):
            return "eventScheduled\(event.number)"
        case let .eventRescheduled(event):
            return "eventRescheduled\(event.number)"
        case let .eventMoved(event):
            return "eventMoved\(event.number)"
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
        case let .scoresPublished(album):
            return "Scores Available - MGM \(album.eventNumber)"
        case let .eventScheduled(event):
            return "Event Scheduled - MGM \(event.number)"
        case let .eventRescheduled(event):
            return "Event Rescheduled - MGM \(event.number)"
        case let .eventMoved(event):
            return "Event Moved - MGM \(event.number)"
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
        case let .scoresPublished(album):
            guard let score = album.score else { return nil }
            let formattedScore = String(format: "%.1f", score)
            return "\"\(album.name)\" scored \(formattedScore)"
        case let .eventScheduled(event):
            guard let dateString = event.dateString else { return nil }
            return "This month's event has been scheduled for \(dateString)"
        case let .eventRescheduled(event):
            guard let dateString = event.dateString else { return nil }
            return "This month's event has been rescheduled for \(dateString)"
        case let .eventMoved(event):
            guard let location = event.location else { return nil }
            return "This month's event has been moved to \(location.name)"
        case .eventCancelled:
            return "This month's event has been cancelled. Check the Facebook group for more details."
        case .playlistPublished:
            return "This month's playlist is now available."
        }
    }
}

private extension Event {
    var dateString: String? {
        guard let date else { return nil }
        let formatter = DateFormatter.mgm_latestEventDateFormatter()
        return formatter.string(from: date)
    }
}
