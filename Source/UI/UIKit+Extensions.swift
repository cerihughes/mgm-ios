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
