import Madog

class MGMResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Navigation>] {
        return [
            LatestEventViewControllerProvider.init,
            ScoresViewControllerProvider.init,
            SettingsViewControllerProvider.init,
            SpotifyLaunchViewControllerProvider.init,
            AppleMapsLaunchViewControllerProvider.init
        ]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return [
            MGMServiceProviderImplementation.init(context:)
        ]
    }
}
