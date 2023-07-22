//
//  MockScoresViewModel.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

@testable import MusicGeekMonthly

class MockScoresViewModel: MockAlbumArtViewModel, ScoresViewModel {
    var albumTypes = ["Classic Albums", "New Albums", "All Albums"]
    var selectedAlbumType = 0
    var dataLoaded = true
    var message: String?
    var retryButtonTitle = "Retry"
    var filterPlaceholder = "FilterPlaceholder"
    var filter: String?

    var scoreViewData = [MockScoreViewData]()

    var numberOfScores: Int {
        scoreViewData.count
    }

    func loadData(_ completion: @escaping () -> Void) {
        completion()
    }

    func scoreViewData(at index: Int) -> ScoreViewData? {
        guard scoreViewData.indices.contains(index) else { return nil }
        return scoreViewData[index]
    }
}

struct MockScoreViewData: ScoreViewData {
    var loadingImage: UIImage?
    var images: [Image]?
    var albumName = "AlbumName"
    var artistName = "ArtistName"
    var rating = "0.0"
    var ratingFontColor = UIColor.goldCup
    var awardImage: UIImage?
    var position = "0"
    var spotifyURL: URL?
}
