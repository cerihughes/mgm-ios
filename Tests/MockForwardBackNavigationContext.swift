//
//  MockForwardBackNavigationContext.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Madog

class MockForwardBackNavigationContext: ForwardBackNavigationContext {
    func navigateForward(token: Any, animated: Bool) -> Bool {
        return false
    }

    func navigateBack(animated: Bool) -> Bool {
        return false
    }

    func navigateBackToRoot(animated: Bool) -> Bool {
        return false
    }
}
