//
//  Navigation.swift
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/09/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

enum Navigation: Equatable {
    case latestEvent
    case scores
    case settings
    case spotify(spotifyURL: URL)
    case appleMaps(locationName: String, latitude: Double, longitude: Double)
}
