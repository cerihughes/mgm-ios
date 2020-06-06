import Foundation

enum EventUpdate: Equatable {
    case newEvent(Event)
    case scoresPublished(Album)
    case eventScheduled(Event)
    case eventRescheduled(Event)
    case eventMoved(Event)
    case eventCancelled(Event)
    case playlistPublished(Event)
}

protocol EventUpdateManager {
    func processEventUpdate(oldEvents: [Event], newEvents: [Event]) -> [EventUpdate]
}

class EventUpdateManagerImplementation: EventUpdateManager {
    func processEventUpdate(oldEvents: [Event], newEvents: [Event]) -> [EventUpdate] {
        if let oldLatestEvent = oldEvents.last, let newLatestEvent = newEvents.last {
            let newPreviousEvent = newEvents.dropLast().last
            return processEventUpdate(oldLatestEvent: oldLatestEvent,
                                      newPreviousEvent: newPreviousEvent,
                                      newLatestEvent: newLatestEvent)
        }
        return []
    }

    private func processEventUpdate(oldLatestEvent: Event, newPreviousEvent: Event?, newLatestEvent: Event) -> [EventUpdate] {
        var results = [EventUpdate]()

        let oldLatestEventNumber = oldLatestEvent.number
        let newLatestEventNumber = newLatestEvent.number

        if oldLatestEventNumber == newLatestEventNumber {
            if oldLatestEvent != newLatestEvent {
                results.append(contentsOf: eventChanged(oldEvent: oldLatestEvent, newEvent: newLatestEvent))
            }
        } else if oldLatestEventNumber < newLatestEventNumber, let newPreviousEvent = newPreviousEvent {
            if oldLatestEventNumber == newPreviousEvent.number {
                results.append(contentsOf: eventChanged(oldEvent: oldLatestEvent, newEvent: newPreviousEvent))
            }
            results.append(contentsOf: eventCreated(newLatestEvent))
        }

        return results
    }

    private func eventCreated(_ newEvent: Event) -> [EventUpdate] {
        guard newEvent.classicAlbum != nil, newEvent.newAlbum != nil else {
            return []
        }
        return [.newEvent(newEvent)]
    }

    private func eventChanged(oldEvent: Event, newEvent: Event) -> [EventUpdate] {
        return [
            playlistChanged(oldEvent: oldEvent, newEvent: newEvent),
            scoresChanged(oldAlbum: oldEvent.classicAlbum, newAlbum: newEvent.classicAlbum),
            scoresChanged(oldAlbum: oldEvent.newAlbum, newAlbum: newEvent.newAlbum),
            dateChanged(oldEvent: oldEvent, newEvent: newEvent)
        ].compactMap { $0 }
    }

    private func playlistChanged(oldEvent: Event, newEvent: Event) -> EventUpdate? {
        guard oldEvent.playlist == nil, newEvent.playlist != nil else {
            return nil
        }
        return .playlistPublished(newEvent)
    }

    private func scoresChanged(oldAlbum: Album?, newAlbum: Album?) -> EventUpdate? {
        guard let newAlbum = newAlbum,
            let newScore = newAlbum.score,
            oldAlbum?.score != newScore else {
            return nil
        }
        return .scoresPublished(newAlbum)
    }

    private func scoresChanged(oldAlbum: Album?, newAlbum: Album?) -> Bool {
        return true
    }

    private func dateChanged(oldEvent: Event, newEvent: Event) -> EventUpdate? {
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
