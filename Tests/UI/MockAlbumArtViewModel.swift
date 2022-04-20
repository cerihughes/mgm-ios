//
//  MockAlbumArtViewModel.swift
//  MusicGeekMonthlyTests
//
//  Created by Ceri Hughes on 20/04/2022.
//  Copyright © 2022 Ceri Hughes. All rights reserved.
//

import UIKit

@testable import MusicGeekMonthly

class MockAlbumArtViewModel: AlbumArtViewModel {
    func loadAlbumCover(largestDimension: Int, viewData: AlbumArtViewData, _ completion: @escaping (UIImage?) -> Void) {
        completion(viewData.loadingImage)
    }

    func cancelLoadAlbumCover(viewData: AlbumArtViewData) {}
}
