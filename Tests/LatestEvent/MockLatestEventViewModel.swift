//
//  MockLatestEventViewModel.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

@testable import MusicGeekMonthly

class MockLatestEventViewModel: LatestEventViewModel {
    var title = "Title"
    var locationName: String?
    var mapReference: MapReference?
    var message: String?
    var retryButtonTitle = "Retry"
    var numberOfEntites = 0
    var isLocationAvailable = false

    var headerTitles = [String]()
    var eventEntityViewModels = [MockLatestEventEntityViewModel]()

    func loadData(_ completion: @escaping () -> Void) {
        completion()
    }

    func headerTitle(for section: Int) -> String? {
        guard headerTitles.indices.contains(section) else { return nil }
        return headerTitles[section]
    }

    func eventEntityViewModel(at index: Int) -> LatestEventEntityViewModel? {
        guard eventEntityViewModels.indices.contains(index) else { return nil }
        return eventEntityViewModels[index]
    }
}

class MockLatestEventEntityViewModel: LatestEventEntityViewModel {
    var entityType = "EntityType"
    var entityName = "EntityName"
    var entityOwner = "EntityOwner"
    var spotifyURL: URL?
    var loadingImage: UIImage?
    var albumCover: UIImage?

    func loadAlbumCover(largestDimension: Int, _ completion: @escaping (UIImage?) -> Void) {
        completion(albumCover)
    }

    func cancelLoadAlbumCover() {
    }
}
