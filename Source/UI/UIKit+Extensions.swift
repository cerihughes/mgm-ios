//
//  UIKit+Extensions.swift
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 30/09/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView ...) {
        subviews.forEach { addSubview($0) }
    }
}

extension UIImage {
    static let album1Loading = UIImage(named: "album1")
    static let album2Loading = UIImage(named: "album2")
    static let album3Loading = UIImage(named: "album3")

    static let goldAward = UIImage(named: "gold")
    static let silverAward = UIImage(named: "silver")
    static let plateAward = UIImage(named: "plate")
    static let noAward = UIImage(named: "none")
}
