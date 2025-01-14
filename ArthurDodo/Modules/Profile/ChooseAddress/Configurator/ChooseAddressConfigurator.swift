final class ChooseAddressConfigurator {
    // MARK: - Properties
    private let storageService: DataStorageService

    // MARK: - Init
    init(storageService: DataStorageService) {
        self.storageService = storageService
    }

    // MARK: - Methods
    func configure() -> ChooseAddressViewController {
        let presenter = ChooseAddressPresenter(storageService: storageService)
        let view = ChooseAddressViewController(output: presenter)

        presenter.view = view

        return view
    }
}

