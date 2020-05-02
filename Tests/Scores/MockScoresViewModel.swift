//
//  MockScoresViewModel.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

@testable import MusicGeekMonthly

class MockScoresViewModel: ScoresViewModel {
    var albumTypes = ["Classic Albums", "New Albums", "All Albums"]
    var selectedAlbumType = 0
    var dataLoaded = true
    var message: String?
    var retryButtonTitle = "Retry"
    var filterPlaceholder = "FilterPlaceholder"
    var filter: String?

    var scoreViewModels = [MockScoreViewModel]()

    var numberOfScores: Int {
        return scoreViewModels.count
    }

    func loadData(_ completion: @escaping () -> Void) {
        completion()
    }

    func scoreViewModel(at index: Int) -> ScoreViewModel? {
        guard scoreViewModels.indices.contains(index) else { return nil }
        return scoreViewModels[index]
    }
}

class MockScoreViewModel: ScoreViewModel {
    var albumName = "AlbumName"
    var artistName = "ArtistName"
    var rating = "0.0"
    var ratingFontColor = UIColor.goldCup
    var awardImage: UIImage?
    var position = "0"
    var spotifyURL: URL?
    var loadingImage: UIImage?

    var albumCover: UIImage?

    func loadAlbumCover(largestDimension: Int, _ completion: @escaping (UIImage?) -> Void) {
        completion(albumCover)
    }

    func cancelLoadAlbumCover() {}
}
