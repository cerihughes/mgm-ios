//
//  LatestEventSnapshotTests.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit
import XCTest

@testable import MusicGeekMonthly

class LatestEventSnapshotTests: MGMSnapshotTests {
    private var viewModel: MockLatestEventViewModel!
    private var viewController: LatestEventViewController!

    override func setUp() {
        super.setUp()

        viewModel = MockLatestEventViewModel()
        viewController = LatestEventViewController(navigationContext: navigationContext, viewModel: viewModel)
    }

    func testLatestEvent() {
        var classicAlbum = MockLatestEventEntityViewData()
        classicAlbum.loadingImage = .album1Loading
        var newAlbum = MockLatestEventEntityViewData()
        newAlbum.loadingImage = .album2Loading
        var playlist = MockLatestEventEntityViewData()
        playlist.loadingImage = .album3Loading
        viewModel.isLocationAvailable = false
        viewModel.headerTitles = ["LOCATION", "LISTENING TO"]
        viewModel.eventEntityViewData = [classicAlbum, newAlbum, playlist]

        FBSnapshotVerifyViewController(viewController)
    }
}
