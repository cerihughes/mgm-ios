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
        let classicAlbum = createViewData(loadingImage: .album1Loading)
        let newAlbum = createViewData(loadingImage: .album2Loading)
        let playlist = createViewData(loadingImage: .album3Loading)
        viewModel.isLocationAvailable = false
        viewModel.headerTitles = ["LOCATION", "LISTENING TO"]
        viewModel.eventEntityViewData = [classicAlbum, newAlbum, playlist]

        FBSnapshotVerifyViewController(viewController)
    }

    private func createViewData(loadingImage: UIImage?) -> LatestEventEntityViewDataImplementation {
        .init(loadingImage: loadingImage,
            images: nil,
            entityType: "EntityType",
            entityName: "EntityName",
            entityOwner: "EntityOwner",
            spotifyURL: nil)
    }
}
