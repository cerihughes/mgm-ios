//
//  ScoresSnapshotTests.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import MusicGeekMonthly

class ScoresSnapshotTests: MGMSnapshotTests {
    private var viewModel: MockScoresViewModel!
    private var viewController: ScoresViewController!

    override func setUp() {
        super.setUp()

        viewModel = MockScoresViewModel()
        viewController = ScoresViewController(navigationContext: navigationContext, viewModel: viewModel)
    }

    func testScores() {
        let album1 = MockScoreViewModel(position: 1, rating: 10, color: .goldCup, awardImage: .goldAward, albumCover: .album1)
        let album2 = MockScoreViewModel(position: 2, rating: 9.9, color: .silverCup, awardImage: .silverAward, albumCover: .album2)
        let album3 = MockScoreViewModel(position: 3, rating: 8.8, color: .bronzeCup, awardImage: .plateAward, albumCover: .album3)
        let album4 = MockScoreViewModel(position: 4, rating: 7.7, color: .greenCup, awardImage: .noAward, albumCover: .album1)
        viewModel.scoreViewModels = [album1, album2, album3, album4]
        FBSnapshotVerifyViewController(viewController)
    }
}

extension MockScoreViewModel {
    convenience init(position: Int, rating: Float, color: UIColor, awardImage: UIImage, albumCover: UIImage) {
        self.init()
        self.position = "\(position)"
        self.rating = String(format: "%.1f", rating)
        ratingFontColor = color
        self.awardImage = awardImage
        self.albumCover = albumCover
    }
}
