import XCTest

class EventUpdateManagerTests: XCTestCase {
    private var cut: EventUpdateManager!

    override func setUp() {
        super.setUp()

        cut = EventUpdateManagerImplementation()
    }

    override func tearDown() {
        cut = nil

        super.tearDown()
    }

    func testNoChanges() {
        let event = Event.create(number: 1,
                                 location: Location.create(latitude: 1.234, longitude: 5.678),
                                 date: Date(),
                                 playlist: Playlist.create(),
                                 classicAlbum: Album.create(type: .classic, score: 8.0),
                                 newAlbum: Album.create(type: .new, score: 8.1))

        let result = cut.processEventUpdate(oldEvents: [event], newEvents: [event])
        XCTAssertEqual(result.count, 0)
    }

    func testNoEvents() {
        let result = cut.processEventUpdate(oldEvents: [], newEvents: [])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_noPrevious() {
        let newEvent = Event.create(number: 1)
        let result = cut.processEventUpdate(oldEvents: [], newEvents: [newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_noAlbums() {
        let oldEvent = Event.create(number: 1)
        let newEvent = Event.create(number: 2)
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_classisAlbum() {
        let oldEvent = Event.create(number: 1)
        let newEvent = Event.create(number: 2, classicAlbum: Album.create(type: .classic))
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_newAlbum() {
        let oldEvent = Event.create(number: 1)
        let newEvent = Event.create(number: 2, newAlbum: Album.create(type: .new))
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_bothAlbums() {
        let oldEvent = Event.create(number: 1)
        let newEvent = Event.create(number: 2, classicAlbum: Album.create(type: .classic), newAlbum: Album.create(type: .new))
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .newEvent(newEvent))
    }

    func testUpdateEvent_addScores() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic, score: 5.0),
                                    newAlbum: Album.create(type: .new, score: 5.0))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent))
    }

    func testUpdateEvent_addClassicScore() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic, score: 5.0),
                                    newAlbum: Album.create(type: .new))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent))
    }

    func testUpdateEvent_addNewScore() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new, score: 5.0))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent))
    }

    func testUpdateEvent_addClassicScore_existingNewScore() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new, score: 5.0))
        let newEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic, score: 5.0),
                                    newAlbum: Album.create(type: .new, score: 5.0))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent))
    }

    func testUpdateEvent_addNewScore_existingClassicScore() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic, score: 5.0),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic, score: 5.0),
                                    newAlbum: Album.create(type: .new, score: 5.0))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent))
    }

    func testUpdateEvent_addDate() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    date: Date(),
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .eventScheduled(newEvent))
    }

    func testUpdateEvent_changeDate() {
        let initialDate = Date()
        let updatedDate = Date(timeInterval: 1, since: initialDate)
        let oldEvent = Event.create(number: 1,
                                    date: initialDate,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    date: updatedDate,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .eventRescheduled(newEvent))
    }

    func testUpdateEvent_removeDate() {
        let oldEvent = Event.create(number: 1,
                                    date: Date(),
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .eventCancelled(newEvent))
    }

    func testPlaylistPublished() {
        let oldEvent = Event.create(number: 1,
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))
        let newEvent = Event.create(number: 1,
                                    playlist: Playlist.create(),
                                    classicAlbum: Album.create(type: .classic),
                                    newAlbum: Album.create(type: .new))

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .playlistPublished(newEvent))
    }
}
