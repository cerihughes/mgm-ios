import Madog

class MGMResolver: Resolver<ResourceLocator> {
    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<ResourceLocator>] {
        return [
            LatestEventViewControllerProvider.init,
            ScoresViewControllerProvider.init,
            SettingsViewControllerProvider.init,
            SpotifyLaunchViewControllerProvider.init,
            AppleMapsLaunchViewControllerProvider.init
        ]
    }

    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return [
            MGMServiceProviderImplementation.init(context:)
        ]
    }
}
