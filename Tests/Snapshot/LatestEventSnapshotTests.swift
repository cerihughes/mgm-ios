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
        let classicAlbum = MockLatestEventEntityViewModel()
        classicAlbum.albumCover = .album1
        let newAlbum = MockLatestEventEntityViewModel()
        newAlbum.albumCover = .album2
        let playlist = MockLatestEventEntityViewModel()
        playlist.albumCover = .album3
        viewModel.isLocationAvailable = false
        viewModel.headerTitles = ["LOCATION", "LISTENING TO"]
        viewModel.eventEntityViewModels = [classicAlbum, newAlbum, playlist]

        FBSnapshotVerifyViewController(viewController)
    }
}
