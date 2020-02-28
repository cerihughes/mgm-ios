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
        return [
            MGMServiceProviderImplementation.init(context:)
        ]
    }
}
