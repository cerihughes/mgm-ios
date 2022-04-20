//
//  MockLatestEventViewModel.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

@testable import MusicGeekMonthly

class MockLatestEventViewModel: MockAlbumArtViewModel, LatestEventViewModel {
    var title = "Title"
    var locationName: String?
    var mapReference: MapReference?
    var message: String?
    var retryButtonTitle = "Retry"
    var isLocationAvailable = false

    var headerTitles = [String]()
    var eventEntityViewData = [LatestEventEntityViewData]()

    var numberOfEntites: Int {
        return eventEntityViewData.count
    }

    func loadData(_ completion: @escaping () -> Void) {
        completion()
    }

    func headerTitle(for section: Int) -> String? {
        guard headerTitles.indices.contains(section) else { return nil }
        return headerTitles[section]
    }

    func eventEntityViewData(at index: Int) -> LatestEventEntityViewData? {
        guard eventEntityViewData.indices.contains(index) else { return nil }
        return eventEntityViewData[index]
    }
}
