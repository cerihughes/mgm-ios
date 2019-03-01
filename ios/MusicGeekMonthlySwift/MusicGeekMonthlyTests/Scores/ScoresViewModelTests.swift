//
//  ScoresViewModelTests.swift
//  MusicGeekMonthlyTests
//
//  Created by Ceri Hughes on 01/03/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

class ScoresViewModelTests: XCTestCase {

    private var viewModelDataLoader: MockViewModelDataLoader!
    private var imageLoader: MockImageLoader!

    override func setUp() {
        super.setUp()

        viewModelDataLoader = MockViewModelDataLoader()
        imageLoader = MockImageLoader()
    }

    override func tearDown() {
        viewModelDataLoader = nil
        imageLoader = nil

        super.tearDown()
    }

    func testAlbums_differentScores() {
        let event1 = createEvent(number: 2, classicAlbumScore: 8.0, newAlbumScore: 7.0)
        let event2 = createEvent(number: 1, classicAlbumScore: 5.0, newAlbumScore: 6.0)
        let event3 = createEvent(number: 1, classicAlbumScore: 10.0, newAlbumScore: 9.0)
        viewModelDataLoader.response = .success([event1, event2, event3])

        let viewModel = ScoresViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
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

    func testAlbums_sameScores() {
        let event1 = createEvent(number: 1, classicAlbumScore: 10.0, newAlbumScore: 9.5)
        let event2 = createEvent(number: 2, classicAlbumScore: 10.0, newAlbumScore: 9.5)
        let event3 = createEvent(number: 3, classicAlbumScore: 10.0, newAlbumScore: 9.5)
        viewModelDataLoader.response = .success([event1, event2, event3])

        let viewModel = ScoresViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
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

    func testAlbums_mixedScores() {
        let event1 = createEvent(number: 1, classicAlbumScore: 4.4, newAlbumScore: 5.5)
        let event2 = createEvent(number: 2, classicAlbumScore: 5.5, newAlbumScore: 4.4)
        let event3 = createEvent(number: 3, classicAlbumScore: 3.3, newAlbumScore: 5.5)
        let event4 = createEvent(number: 3, classicAlbumScore: 6.6, newAlbumScore: 6.6)
        let event5 = createEvent(number: 3, classicAlbumScore: 6.6, newAlbumScore: 6.6)
        viewModelDataLoader.response = .success([event1, event2, event3, event4, event5])

        let viewModel = ScoresViewModelImplementation(dataLoader: viewModelDataLoader, imageLoader: imageLoader)
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

    private func createEvent(number: Int, classicAlbumScore: Float, newAlbumScore: Float) -> Event {
        let classicAlbum = createAlbum(type: .classic, score: classicAlbumScore)
        let newAlbum = createAlbum(type: .new, score: newAlbumScore)
        return Event(number: number, location: nil, date: nil, playlist: nil, classicAlbum: classicAlbum, newAlbum: newAlbum)
    }

    private func createAlbum(type: AlbumType, score: Float) -> Album {
        return Album(type: type, spotifyId: nil, name: "name", artist: "artist", score: score, images: [])
    }

    private func assert(viewModel: ScoresViewModel, positions: [String], ratings: [String]) {
        XCTAssertEqual(viewModel.numberOfScores, ratings.count)
        for index in 0 ..< viewModel.numberOfScores {
            let scoreViewModel = viewModel.scoreViewModel(at: index)!
            XCTAssertEqual(scoreViewModel.position, positions[index])
            XCTAssertEqual(scoreViewModel.rating, ratings[index])
        }
    }
}
