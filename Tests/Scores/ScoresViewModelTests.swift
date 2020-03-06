import XCTest

@testable import MusicGeekMonthly

class ScoresViewModelTests: DataRepositoryTestCase {
    private var encoder: JSONEncoder!
    private var imageLoader: MockImageLoader!

    override func setUp() {
        super.setUp()

        encoder = JSONEncoder.create()
        imageLoader = MockImageLoader()
    }

    override func tearDown() {
        imageLoader = nil
        encoder = nil

        super.tearDown()
    }

    func testAlbums_scoreSort_differentScores() {
        let event1 = Event.create(number: 1, classicAlbumScore: 8.0, newAlbumScore: 7.0)
        let event2 = Event.create(number: 2, classicAlbumScore: 5.0, newAlbumScore: 6.0)
        let event3 = Event.create(number: 3, classicAlbumScore: 10.0, newAlbumScore: 9.0)
        let data = try! encoder.encode(events: [event1, event2, event3])
        remoteDataSource.loadEventDataResponse = .success(data)

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let loadingExpectation = expectation(description: "Data Loaded")
        viewModel.loadData {
            loadingExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        viewModel.selectedAlbumType = 0
        assert(viewModel: viewModel,
               positions: ["1", "2", "3"],
               ratings: ["10.0", "8.0", "5.0"])

        viewModel.selectedAlbumType = 1
        assert(viewModel: viewModel,
               positions: ["1", "2", "3"],
               ratings: ["9.0", "7.0", "6.0"])

        viewModel.selectedAlbumType = 2
        assert(viewModel: viewModel,
               positions: ["1", "2", "3", "4", "5", "6"],
               ratings: ["10.0", "9.0", "8.0", "7.0", "6.0", "5.0"])
    }

    func testAlbums_scoreSort_sameScores() {
        let event1 = Event.create(number: 1, classicAlbumScore: 10.0, newAlbumScore: 9.5)
        let event2 = Event.create(number: 2, classicAlbumScore: 10.0, newAlbumScore: 9.5)
        let event3 = Event.create(number: 3, classicAlbumScore: 10.0, newAlbumScore: 9.5)
        let data = try! encoder.encode([event1, event2, event3])
        remoteDataSource.loadEventDataResponse = .success(data)

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let loadingExpectation = expectation(description: "Data Loaded")
        viewModel.loadData {
            loadingExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        viewModel.selectedAlbumType = 0
        assert(viewModel: viewModel,
               positions: ["1", "1", "1"],
               ratings: ["10.0", "10.0", "10.0"])

        viewModel.selectedAlbumType = 1
        assert(viewModel: viewModel,
               positions: ["1", "1", "1"],
               ratings: ["9.5", "9.5", "9.5"])

        viewModel.selectedAlbumType = 2
        assert(viewModel: viewModel,
               positions: ["1", "1", "1", "4", "4", "4"],
               ratings: ["10.0", "10.0", "10.0", "9.5", "9.5", "9.5"])
    }

    func testAlbums_scoreSort_mixedScores() {
        let event1 = Event.create(number: 1, classicAlbumScore: 4.4, newAlbumScore: 5.5)
        let event2 = Event.create(number: 2, classicAlbumScore: 5.5, newAlbumScore: 4.4)
        let event3 = Event.create(number: 3, classicAlbumScore: 3.3, newAlbumScore: 5.5)
        let event4 = Event.create(number: 4, classicAlbumScore: 6.6, newAlbumScore: 6.6)
        let event5 = Event.create(number: 5, classicAlbumScore: 6.6, newAlbumScore: 6.6)
        let data = try! encoder.encode([event1, event2, event3, event4, event5])
        remoteDataSource.loadEventDataResponse = .success(data)

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let loadingExpectation = expectation(description: "Data Loaded")
        viewModel.loadData {
            loadingExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        viewModel.selectedAlbumType = 0
        assert(viewModel: viewModel,
               positions: ["1", "1", "3", "4", "5"],
               ratings: ["6.6", "6.6", "5.5", "4.4", "3.3"])

        viewModel.selectedAlbumType = 1
        assert(viewModel: viewModel,
               positions: ["1", "1", "3", "3", "5"],
               ratings: ["6.6", "6.6", "5.5", "5.5", "4.4"])

        viewModel.selectedAlbumType = 2
        assert(viewModel: viewModel,
               positions: ["1", "1", "1", "1", "5", "5", "5", "8", "8", "10"],
               ratings: ["6.6", "6.6", "6.6", "6.6", "5.5", "5.5", "5.5", "4.4", "4.4", "3.3"])
    }

    func testAlbums_nameSort() {
        let event1 = Event.create(number: 1, classicAlbumName: "AA", newAlbumName: "dd")
        let event2 = Event.create(number: 2, classicAlbumName: "bb", newAlbumName: "EE")
        let event3 = Event.create(number: 3, classicAlbumName: "CC", newAlbumName: "ff")
        let data = try! encoder.encode([event1, event2, event3])
        remoteDataSource.loadEventDataResponse = .success(data)

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let loadingExpectation = expectation(description: "Data Loaded")
        viewModel.loadData {
            loadingExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        viewModel.selectedAlbumType = 2
        assert(viewModel: viewModel,
               positions: ["1", "1", "1", "1", "1", "1"],
               albumNames: ["AA", "bb", "CC", "dd", "EE", "ff"])
    }

    func testAlbums_artistSort() {
        let event1 = Event.create(number: 1, classicAlbumArtist: "Aa", newAlbumArtist: "ab")
        let event2 = Event.create(number: 2, classicAlbumArtist: "ACa1", newAlbumArtist: "ACA2")
        let event3 = Event.create(number: 3, classicAlbumArtist: "aDEe3", newAlbumArtist: "AdeE4")
        let data = try! encoder.encode([event1, event2, event3])
        remoteDataSource.loadEventDataResponse = .success(data)

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let loadingExpectation = expectation(description: "Data Loaded")
        viewModel.loadData {
            loadingExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        viewModel.selectedAlbumType = 2
        assert(viewModel: viewModel,
               positions: ["1", "1", "1", "1", "1", "1"],
               artistNames: ["Aa", "ab", "ACa1", "ACA2", "aDEe3", "AdeE4"])
    }

    func testAlbums_allSorts() {
        let classicAlbum1 = Album.create(type: .classic, name: "zzz", artist: "aaa", score: 8.0)
        let classicAlbum2 = Album.create(type: .classic, name: "B2", artist: "yyy", score: 9.0)
        let classicAlbum3 = Album.create(type: .classic, name: "A0", artist: "ZZZ", score: 10.0)
        let classicAlbum4 = Album.create(type: .classic, name: "B2", artist: "xxx", score: 9.0)
        let classicAlbum5 = Album.create(type: .classic, name: "A1", artist: "Z1", score: 10.0)

        let newAlbum1 = Album.create(type: .new, name: "2", artist: "Art", score: 7.0)
        let newAlbum2 = Album.create(type: .new, name: "aaa", artist: "zzz", score: 8.0)
        let newAlbum3 = Album.create(type: .new, name: "1", artist: "Art", score: 7.0)
        let newAlbum4 = Album.create(type: .new, name: "B2", artist: "zzz", score: 9.0)
        let newAlbum5 = Album.create(type: .new, name: "A1", artist: "A2", score: 10.0)

        let event1 = Event.create(number: 1, classicAlbum: classicAlbum1, newAlbum: newAlbum1)
        let event2 = Event.create(number: 2, classicAlbum: classicAlbum2, newAlbum: newAlbum2)
        let event3 = Event.create(number: 3, classicAlbum: classicAlbum3, newAlbum: newAlbum3)
        let event4 = Event.create(number: 4, classicAlbum: classicAlbum4, newAlbum: newAlbum4)
        let event5 = Event.create(number: 5, classicAlbum: classicAlbum5, newAlbum: newAlbum5)

        let data = try! encoder.encode([event1, event2, event3, event4, event5])
        remoteDataSource.loadEventDataResponse = .success(data)

        let viewModel = ScoresViewModelImplementation(dataRepository: dataRepository, imageLoader: imageLoader)
        let loadingExpectation = expectation(description: "Data Loaded")
        viewModel.loadData {
            loadingExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)

        viewModel.selectedAlbumType = 2
        assert(viewModel: viewModel,
               positions: ["1", "1", "1", "4", "4", "4", "7", "7", "9", "9"],
               ratings: ["10.0", "10.0", "10.0", "9.0", "9.0", "9.0", "8.0", "8.0", "7.0", "7.0"],
               albumNames: ["A0", "A1", "A1", "B2", "B2", "B2", "aaa", "zzz", "1", "2"],
               artistNames: ["ZZZ", "A2", "Z1", "xxx", "yyy", "zzz", "zzz", "aaa", "Art", "Art"])
    }

    private func assert(viewModel: ScoresViewModel,
                        positions: [String],
                        ratings: [String]? = nil,
                        albumNames: [String]? = nil,
                        artistNames: [String]? = nil) {
        XCTAssertEqual(viewModel.numberOfScores, positions.count)
        for index in 0 ..< viewModel.numberOfScores {
            let scoreViewModel = viewModel.scoreViewModel(at: index)!
            XCTAssertEqual(scoreViewModel.position, positions[index])
            if let ratings = ratings {
                XCTAssertEqual(scoreViewModel.rating, ratings[index])
            }
            if let albumNames = albumNames {
                XCTAssertEqual(scoreViewModel.albumName, albumNames[index])
            }
            if let artistNames = artistNames {
                XCTAssertEqual(scoreViewModel.artistName, artistNames[index])
            }
        }
    }
}
