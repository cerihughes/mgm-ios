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
        let event1 = EventApiModel.create(number: 1,
                                          date: "10/12/2020",
                                          location: LocationApiModel.create(latitude: 1.234, longitude: 5.678),
                                          classicAlbum: AlbumApiModel.create(type: .classic, score: 8.0),
                                          newAlbum: AlbumApiModel.create(type: .new, score: 8.1),
                                          playlist: PlaylistApiModel.create())
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1], newEvents: [event1])
        XCTAssertEqual(result.count, 0)
    }

    func testNoEvents() {
        let result = cut.processEventUpdate(oldEvents: [], newEvents: [])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_noPrevious() {
        let event1 = EventApiModel.create(number: 1)
            .convert()
        let result = cut.processEventUpdate(oldEvents: [], newEvents: [event1])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_noAlbums() {
        let event1 = EventApiModel.create(number: 1)
            .convert()
        let event2 = EventApiModel.create(number: 2)
            .convert()
        let result = cut.processEventUpdate(oldEvents: [event1], newEvents: [event1, event2])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_classisAlbum() {
        let event1 = EventApiModel.create(number: 1)
            .convert()
        let event2 = EventApiModel.create(number: 2, classicAlbum: AlbumApiModel.create(type: .classic))
            .convert()
        let result = cut.processEventUpdate(oldEvents: [event1], newEvents: [event1, event2])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_newAlbum() {
        let event1 = EventApiModel.create(number: 1)
            .convert()
        let event2 = EventApiModel.create(number: 2, newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let result = cut.processEventUpdate(oldEvents: [event1], newEvents: [event1, event2])
        XCTAssertEqual(result.count, 0)
    }

    func testNewEvent_bothAlbums() {
        let event1 = EventApiModel.create(number: 1)
            .convert()
        let event2 = EventApiModel.create(number: 2,
                                          classicAlbum: AlbumApiModel.create(type: .classic),
                                          newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let result = cut.processEventUpdate(oldEvents: [event1], newEvents: [event1, event2])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "New Event - MGM 2")
        XCTAssertEqual(notification.body, "Next month's albums are now available.")
    }

    func testUpdateEvent_addScores() {
        let event1a = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic, name: "Classic Album", score: 5.0),
                                           newAlbum: AlbumApiModel.create(type: .new, name: "New Album", score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 2)

        let notification1 = result[0]
        let notification2 = result[1]
        XCTAssertEqual(notification1.title, "Scores Available - MGM 1")
        XCTAssertEqual(notification1.body, "\"Classic Album\" scored 5.0")
        XCTAssertEqual(notification2.title, "Scores Available - MGM 1")
        XCTAssertEqual(notification2.body, "\"New Album\" scored 5.0")
    }

    func testUpdateEvent_addClassicScore() {
        let event1a = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic, score: 6.29),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Scores Available - MGM 1")
        XCTAssertEqual(notification.body, "\"name\" scored 6.3")
    }

    func testUpdateEvent_addNewScore() {
        let event11a = EventApiModel.create(number: 11,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event11b = EventApiModel.create(number: 11,
                                            classicAlbum: AlbumApiModel.create(type: .classic),
                                            newAlbum: AlbumApiModel.create(type: .new, score: 0.0001))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event11a], newEvents: [event11b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Scores Available - MGM 11")
        XCTAssertEqual(notification.body, "\"name\" scored 0.0")
    }

    func testUpdateEvent_addClassicScore_existingNewScore() {
        let event131a = EventApiModel.create(number: 131,
                                             classicAlbum: AlbumApiModel.create(type: .classic),
                                             newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()
        let event131b = EventApiModel.create(number: 131,
                                             classicAlbum: AlbumApiModel.create(type: .classic, score: 2.34),
                                             newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event131a], newEvents: [event131b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Scores Available - MGM 131")
        XCTAssertEqual(notification.body, "\"name\" scored 2.3")
    }

    func testUpdateEvent_addNewScore_existingClassicScore() {
        let event1a = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic, score: 5.0),
                                           newAlbum: AlbumApiModel.create(type: .new, score: 5.0))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Scores Available - MGM 1")
        XCTAssertEqual(notification.body, "\"name\" scored 5.0")
    }

    func testUpdateEvent_addDate() {
        let event1a = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           date: "01/01/2020",
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Event Scheduled - MGM 1")
        XCTAssertEqual(notification.body, "This month's event has been scheduled for January 1, 2020")
    }

    func testUpdateEvent_changeDate() {
        let initialDate = "01/01/2020"
        let updatedDate = "02/02/2020"
        let event1a = EventApiModel.create(number: 1,
                                           date: initialDate,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           date: updatedDate,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Event Rescheduled - MGM 1")
        XCTAssertEqual(notification.body, "This month's event has been rescheduled for February 2, 2020")
    }

    func testUpdateEvent_removeDate() {
        let event1a = EventApiModel.create(number: 1,
                                           date: "01/01/2020",
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Event Cancelled - MGM 1")
        XCTAssertEqual(notification.body, "This month's event has been cancelled. Check the Facebook group for more details.")
    }

    func testPlaylistPublished() {
        let event1a = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           newAlbum: AlbumApiModel.create(type: .new))
            .convert()
        let event1b = EventApiModel.create(number: 1,
                                           classicAlbum: AlbumApiModel.create(type: .classic),
                                           
                                           newAlbum: AlbumApiModel.create(type: .new),
                                           playlist: PlaylistApiModel.create())
            .convert()

        let result = cut.processEventUpdate(oldEvents: [event1a], newEvents: [event1b])
        XCTAssertEqual(result.count, 1)

        let notification = result[0]
        XCTAssertEqual(notification.title, "Playlist Available - MGM 1")
        XCTAssertEqual(notification.body, "This month's playlist is now available.")
    }
}
