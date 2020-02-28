import Foundation

protocol EventUpdateManager {
    func processEventUpdate(oldEvents: [Event], newEvents: [Event]) -> [LocalNotificationType]
}

class EventUpdateManagerImplementation: EventUpdateManager {
    func processEventUpdate(oldEvents: [Event], newEvents: [Event]) -> [LocalNotificationType] {
        var results = [LocalNotificationType]()
        guard let oldLastEvent = oldEvents.last,
            let newLastEvent = newEvents.last else {
            return results
        }

        let oldNumber = oldLastEvent.number
        let newNumber = newLastEvent.number
        if oldNumber == newNumber {
            if oldLastEvent != newLastEvent {
                results.append(contentsOf: eventChanged(oldEvent: oldLastEvent, newEvent: newLastEvent))
            }
        } else if oldNumber < newNumber {
            if let newUpdatedEvent = newEvents.findEvent(number: oldNumber) {
                results.append(contentsOf: eventChanged(oldEvent: oldLastEvent, newEvent: newUpdatedEvent))
            }
            results.append(contentsOf: eventCreated(newLastEvent))
        }

        return results
    }

    private func eventCreated(_ newEvent: Event) -> [LocalNotificationType] {
        guard newEvent.classicAlbum != nil, newEvent.newAlbum != nil else {
            return []
        }
        return [.newEvent(newEvent)]
    }

    private func eventChanged(oldEvent: Event, newEvent: Event) -> [LocalNotificationType] {
        return [
            playlistChanged(oldEvent: oldEvent, newEvent: newEvent),
            scoresChanged(oldEvent: oldEvent, newEvent: newEvent),
            dateChanged(oldEvent: oldEvent, newEvent: newEvent)
        ].compactMap { $0 }
    }

    private func playlistChanged(oldEvent: Event, newEvent: Event) -> LocalNotificationType? {
        guard oldEvent.playlist == nil, newEvent.playlist != nil else {
            return nil
        }
        return .playlistPublished(newEvent)
    }

    private func scoresChanged(oldEvent: Event, newEvent: Event) -> LocalNotificationType? {
        guard scoresChanged(oldAlbum: oldEvent.classicAlbum, newAlbum: newEvent.classicAlbum) ||
            scoresChanged(oldAlbum: oldEvent.newAlbum, newAlbum: newEvent.newAlbum) else {
            return nil
        }
        return .scoresPublished(newEvent)
    }

    private func scoresChanged(oldAlbum: Album?, newAlbum: Album?) -> Bool {
        guard let newAlbum = newAlbum,
            let newScore = newAlbum.score,
            oldAlbum?.score != newScore else {
            return false
        }
        return true
    }

    private func dateChanged(oldEvent: Event, newEvent: Event) -> LocalNotificationType? {
        switch (oldEvent.date, newEvent.date) {
        case (nil, nil):
            return nil
        case (nil, _):
            return .eventScheduled(newEvent)
        case (_, nil):
            return .eventCancelled(newEvent)
        case (_, _):
            return .eventRescheduled(newEvent)
        }
    }
}

private extension Collection where Element == Event {
    func findEvent(number: Int) -> Event? {
        return filter { $0.number == number }
            .first
    }
}
