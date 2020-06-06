import Madog

class MGMResolver: Resolver<ResourceLocator> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<ResourceLocator>] {
        return [
            LatestEventViewControllerProvider.init,
            ScoresViewControllerProvider.init,
            SettingsViewControllerProvider.init,
            SpotifyLaunchViewControllerProvider.init,
            AppleMapsLaunchViewControllerProvider.init
        ]
    }

    override func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return [
            MGMServiceProviderImplementation.init(context:)
        ]
    }
}
