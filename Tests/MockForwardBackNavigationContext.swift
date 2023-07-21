//
//  MockForwardBackNavigationContext.swift
//  MusicGeekMonthlyTests
//
//  Created by Home on 02/05/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Madog

class MockForwardBackNavigationContext<T>: ForwardBackNavigationContext {
    var presentingContext: AnyContext<T>?

    func change<VC, C, TD>(
        to identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: ViewController, TD: TokenData {
        nil
    }

    func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        true
    }

    func navigateForward(token: T, animated: Bool) -> Bool {
        return false
    }

    func navigateBack(animated: Bool) -> Bool {
        return false
    }

    func navigateBackToRoot(animated: Bool) -> Bool {
        return false
    }
}
