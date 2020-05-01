import MGMRemoteApiClient
import XCTest

@testable import MusicGeekMonthly

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
        let event = EventApiModel.create(number: 1,
                                         date: "10/12/2020",
                                         location: LocationApiModel.create(latitude: 1.234, longitude: 5.678),
                                         classicAlbum: AlbumApiModel.create(type: .classic, score: 8.0),
                                         newAlbum: AlbumApiModel.create(type: .new, score: 8.1),
                                         playlist: PlaylistApiModel.create())
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event], newEvents: [event])
        XCTAssertEqual(result.count, 0)
    }

    func testNoEvents() {
        let result = cut.processEventUpdate(oldEvents: [], newEvents: [])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_noPrevious() {
        let newEvent = EventApiModel.create(number: 1)
            .convert()
        let result = cut.processEventUpdate(oldEvents: [], newEvents: [newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_noAlbums() {
        let oldEvent = EventApiModel.create(number: 1)
            .convert()
        let newEvent = EventApiModel.create(number: 2)
            .convert()
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_classisAlbum() {
        let oldEvent = EventApiModel.create(number: 1)
            .convert()
        let newEvent = EventApiModel.create(number: 2,
                                            classicAlbum: AlbumApiModel.create(type: .classic))
            .convert()
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_newAlbum() {
        let oldEvent = EventApiModel.create(number: 1)
            .convert()
        let newEvent = EventApiModel.create(number: 2,
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_bothAlbums() {
        let oldEvent = EventApiModel.create(number: 1)
            .convert()
        let newEvent = EventApiModel.create(number: 2,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [oldEvent, newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .newEvent(newEvent))
    }

    func testUpdateEvent_addScores() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                            newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 2)

        XCTAssertEqual(result[0], .scoresPublished(newEvent.classicAlbum!))
        XCTAssertEqual(result[1], .scoresPublished(newEvent.newAlbum!))
    }

    func testUpdateEvent_addClassicScore() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent.classicAlbum!))
    }

    func testUpdateEvent_addNewScore() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent.newAlbum!))
    }

    func testUpdateEvent_addClassicScore_existingNewScore() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                            newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent.classicAlbum!))
    }

    func testUpdateEvent_addNewScore_existingClassicScore() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                            newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .scoresPublished(newEvent.newAlbum!))
    }

    func testUpdateEvent_addDate() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            date: "01/01/2020",
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .eventScheduled(newEvent))
    }

    func testUpdateEvent_changeDate() {
        let initialDate = "01/01/2020"
        let updatedDate = "02/02/2020"
        let oldEvent = EventApiModel.create(number: 1,
                                            date: initialDate,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            date: updatedDate,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .eventRescheduled(newEvent))
    }

    func testUpdateEvent_removeDate() {
        let oldEvent = EventApiModel.create(number: 1,
                                            date: "01/01/2020",
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .eventCancelled(newEvent))
    }

    func testPlaylistPublished() {
        let oldEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let newEvent = EventApiModel.create(number: 1,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            
                                            newAlbum: AlbumApiModel.create(type: .new),
                                            playlist: PlaylistApiModel.create())
            .convert()

        let result = cut.processEventUpdate(oldEvents: [oldEvent], newEvents: [newEvent])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification, .playlistPublished(newEvent))
    }
}
