//
//  LatestEventSnapshotTests.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import FBSnapshotTestCase
import XCTest

@testable import MusicGeekMonthly

class LatestEventSnapshotTests: FBSnapshotTestCase {
    private var navigationContext: MockForwardBackNavigationContext!
    private var viewModel: MockLatestEventViewModel!
    private var viewController: LatestEventViewController!

    override func setUp() {
        super.setUp()

        navigationContext = MockForwardBackNavigationContext()
        viewModel = MockLatestEventViewModel()
        viewController = LatestEventViewController(navigationContext: navigationContext, viewModel: viewModel)

        recordMode = false
    }

    func testLatestEvent() {
        let classicAlbum = MockLatestEventEntityViewModel()
        classicAlbum.albumCover = UIImage(named: "album1")
        let newAlbum = MockLatestEventEntityViewModel()
        newAlbum.albumCover = UIImage(named: "album2")
        let playlist = MockLatestEventEntityViewModel()
        playlist.albumCover = UIImage(named: "album3")
        viewModel.isLocationAvailable = true
        viewModel.locationName = "Location Name"
        viewModel.headerTitles = ["LOCATION", "LISTENING TO"]
        viewModel.numberOfEntites = 3
        viewModel.eventEntityViewModels = [classicAlbum, newAlbum, playlist]
        FBSnapshotVerifyViewController(viewController)
    }
}
