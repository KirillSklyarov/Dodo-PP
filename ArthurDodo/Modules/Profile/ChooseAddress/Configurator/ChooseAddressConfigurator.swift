final class ChooseAddressConfigurator {
    // MARK: - Properties
    private let moduleFactory: ProfileModuleFactory
    private let storageService: DataStorageService

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory, storageService: DataStorageService) {
        self.moduleFactory = moduleFactory
        self.storageService = storageService
    }

    // MARK: - Methods
    func configure() -> ChooseAddressViewController {
        let router = ChooseAddressRouter(moduleFactory: moduleFactory)
        let presenter = ChooseAddressPresenter(router: router, storageService: storageService)
        let view = ChooseAddressViewController(output: presenter)

        presenter.view = view
        router.view = view

        return view
    }
}

