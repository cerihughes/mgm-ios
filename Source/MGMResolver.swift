import Madog

class MGMResolver: Resolver<Navigation> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<Navigation>] {
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
