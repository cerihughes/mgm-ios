//
//  MGMResolver.swift
//  MusicGeekMonthly
//
//  Created by Ceri Hughes on 04/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog

class MGMResolver: Resolver<ResourceLocator> {
    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<ResourceLocator>] {
        let latestEvent = { LatestEventViewControllerProvider() }
        let scores = { ScoresViewControllerProvider() }
        let spotify = { SpotifyLaunchViewControllerProvider() }
        let appleMaps = { AppleMapsLaunchViewControllerProvider() }
        return [latestEvent, scores, spotify, appleMaps]
    }

    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        let serviceProviderCreationFunction = { context in ViewModelDataLoaderServiceProvider(context: context) }
        return [serviceProviderCreationFunction]
    }
}
