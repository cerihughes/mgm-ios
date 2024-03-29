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
            return processEventUpdate(
                oldLatestEvent: oldLatestEvent,
                newPreviousEvent: newPreviousEvent,
                newLatestEvent: newLatestEvent
            )
        }
        return []
    }

    private func processEventUpdate(
        oldLatestEvent: Event,
        newPreviousEvent: Event?,
        newLatestEvent: Event
    ) -> [EventUpdate] {
        var results = [EventUpdate]()

        let oldLatestEventNumber = oldLatestEvent.number
        let newLatestEventNumber = newLatestEvent.number

        if oldLatestEventNumber == newLatestEventNumber {
            if oldLatestEvent != newLatestEvent {
                results.append(contentsOf: eventChanged(oldEvent: oldLatestEvent, newEvent: newLatestEvent))
            }
        } else if oldLatestEventNumber < newLatestEventNumber, let newPreviousEvent {
            if oldLatestEventNumber == newPreviousEvent.number {
                results.append(contentsOf: eventChanged(oldEvent: oldLatestEvent, newEvent: newPreviousEvent))
            }
            results.append(contentsOf: eventCreated(newLatestEvent))
        }

        return results
    }

    private func eventCreated(_ newEvent: Event) -> [EventUpdate] {
        // If there's already a classic or new score, the event has taken place, so don't send an update.
        guard
            let classicAlbum = newEvent.classicAlbum,
            let newAlbum = newEvent.newAlbum,
            classicAlbum.score == nil,
            newAlbum.score == nil
        else { return [] }
        return [.newEvent(newEvent)]
    }

    private func eventChanged(oldEvent: Event, newEvent: Event) -> [EventUpdate] {
        [
            playlistChanged(oldEvent: oldEvent, newEvent: newEvent),
            scoresChanged(oldAlbum: oldEvent.classicAlbum, newAlbum: newEvent.classicAlbum),
            scoresChanged(oldAlbum: oldEvent.newAlbum, newAlbum: newEvent.newAlbum),
            dateChanged(oldEvent: oldEvent, newEvent: newEvent),
            locationChanged(oldEvent: oldEvent, newEvent: newEvent)
        ].compactMap { $0 }
    }

    private func playlistChanged(oldEvent: Event, newEvent: Event) -> EventUpdate? {
        // If there's already a classic or new score, the event has taken place, so don't send an update.
        guard newEvent.classicAlbum?.score == nil, newEvent.newAlbum?.score == nil else {
            return nil
        }
        guard oldEvent.playlist == nil, newEvent.playlist != nil else {
            return nil
        }
        return .playlistPublished(newEvent)
    }

    private func scoresChanged(oldAlbum: Album?, newAlbum: Album?) -> EventUpdate? {
        guard let newAlbum, newAlbum.score != nil, oldAlbum?.score == nil else { return nil }
        return .scoresPublished(newAlbum)
    }

    private func dateChanged(oldEvent: Event, newEvent: Event) -> EventUpdate? {
        // If there's already a classic or new score, the event has taken place, so don't send an update.
        guard newEvent.classicAlbum?.score == nil, newEvent.newAlbum?.score == nil else {
            return nil
        }

        let oldDate = oldEvent.date
        let newDate = newEvent.date

        guard oldDate != newDate else {
            return nil
        }

        switch (oldDate, newDate) {
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

    private func locationChanged(oldEvent: Event, newEvent: Event) -> EventUpdate? {
        // If there's already a classic or new score, the event has taken place, so don't send an update.
        guard newEvent.classicAlbum?.score == nil, newEvent.newAlbum?.score == nil else { return nil }

        // We only care if there was an old location and there's a different new location
        guard
            let oldLocation = oldEvent.location,
            let newLocation = newEvent.location,
            oldLocation != newLocation
        else { return nil }

        return .eventMoved(newEvent)
    }
}
