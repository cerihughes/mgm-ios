//
//  MGMSnapshotTestCase.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import FBSnapshotTestCase
import UIKit
import XCTest

class MGMSnapshotTests: FBSnapshotTestCase {
    var navigationContext: MockForwardBackNavigationContext!

    override func setUp() {
        super.setUp()

        navigationContext = MockForwardBackNavigationContext()

        recordMode = false
    }
}

extension UIImage {
    static let album1 = UIImage(named: "album1")!
    static let album2 = UIImage(named: "album2")!
    static let album3 = UIImage(named: "album3")!

    static let goldAward = UIImage(named: "gold")!
    static let silverAward = UIImage(named: "silver")!
    static let plateAward = UIImage(named: "plate")!
    static let noAward = UIImage(named: "none")!
}
