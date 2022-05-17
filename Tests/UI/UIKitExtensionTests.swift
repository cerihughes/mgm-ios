//
//  UIKitExtensionTests.swift
//  MusicGeekMonthlyTests
//
//  Created by Ceri Hughes on 20/04/2022.
//  Copyright © 2022 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import MusicGeekMonthly

class UIKitExtensionTests: XCTestCase {

    func testAlbum1LoadingImage() {
        XCTAssertNotNil(UIImage.album1Loading)
    }

    func testAlbum2LoadingImage() {
        XCTAssertNotNil(UIImage.album2Loading)
    }

    func testAlbum3LoadingImage() {
        XCTAssertNotNil(UIImage.album3Loading)
    }

    func testGoldAwardImage() {
        XCTAssertNotNil(UIImage.goldAward)
    }

    func testSilverAwardImage() {
        XCTAssertNotNil(UIImage.silverAward)
    }

    func testPlateAwardImage() {
        XCTAssertNotNil(UIImage.plateAward)
    }

    func testNoAwardImage() {
        XCTAssertNotNil(UIImage.noAward)
    }
}
