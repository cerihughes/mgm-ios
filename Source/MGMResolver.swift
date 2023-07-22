import Madog

class MGMResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Navigation>] {
        [
            LatestEventViewControllerProvider.init,
            ScoresViewControllerProvider.init,
            SettingsViewControllerProvider.init,
            SpotifyLaunchViewControllerProvider.init,
            AppleMapsLaunchViewControllerProvider.init
        ]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [
            MGMServiceProviderImplementation.init(context:)
        ]
    }
}
