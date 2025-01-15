
final class MainConfigurator {
    // MARK: - Properties
    private let storage: MainStorage
    private let featureTogglesService: FeatureToggleService

    // MARK: - Init
    init(storage: MainStorage, featureTogglesService: FeatureToggleService) {
        self.storage = storage
        self.featureTogglesService = featureTogglesService
    }

    // MARK: - Methods
    func configure() -> MainViewController {
        let presenter = MainPresenter(storage: storage, featureTogglesService: featureTogglesService)
        let view = MainViewController(output: presenter)

        presenter.view = view

        return view
    }
}
