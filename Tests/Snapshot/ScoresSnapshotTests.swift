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
        let album1 = MockScoreViewData(loadingImage: .album1Loading, position: 1, rating: 10, color: .goldCup, awardImage: .goldAward)
        let album2 = MockScoreViewData(loadingImage: .album2Loading, position: 2, rating: 9.9, color: .silverCup, awardImage: .silverAward)
        let album3 = MockScoreViewData(loadingImage: .album3Loading, position: 3, rating: 8.8, color: .bronzeCup, awardImage: .plateAward)
        let album4 = MockScoreViewData(loadingImage: .album1Loading, position: 4, rating: 7.7, color: .greenCup, awardImage: .noAward)
        viewModel.scoreViewData = [album1, album2, album3, album4]

        FBSnapshotVerifyViewController(viewController)
    }
}

extension MockScoreViewData {
    init(loadingImage: UIImage?, position: Int, rating: Float, color: UIColor, awardImage: UIImage?) {
        self.init()
        self.loadingImage = loadingImage
        self.position = "\(position)"
        self.rating = String(format: "%.1f", rating)
        ratingFontColor = color
        self.awardImage = awardImage
    }
}
