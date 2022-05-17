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

class MGMSnapshotTests: FBSnapshotTestCase {
    var navigationContext: MockForwardBackNavigationContext!

    override func setUp() {
        super.setUp()

        navigationContext = MockForwardBackNavigationContext()

        recordMode = false
        fileNameOptions = [.device, .OS, .screenSize, .screenScale]
    }
}
