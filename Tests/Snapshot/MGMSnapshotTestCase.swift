//
//  MGMSnapshotTestCase.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import iOSSnapshotTestCase
import UIKit
import XCTest

@testable import MusicGeekMonthly

class MGMSnapshotTests: FBSnapshotTestCase {
    var navigationContext: MockForwardBackNavigationContext<Navigation>!

    override func setUp() {
        super.setUp()

        navigationContext = MockForwardBackNavigationContext()

        recordMode = true
        fileNameOptions = [.device, .OS, .screenSize, .screenScale]
    }
}
