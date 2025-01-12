final class DeliveryConfigurator {
    // MARK: - Properties
    private let storageService: DataStorageService
    private let storage: DeliveryStorage

    // MARK: - Init
    init(storage: DeliveryStorage, storageService: DataStorageService) {
        self.storage = storage
        self.storageService = storageService
    }

    // MARK: - Methods
    func configure() -> DeliveryViewController {
        let presenter = DeliveryPresenter(storageService: storageService, storage: storage)
        let view = DeliveryViewController(output: presenter)

        presenter.view = view

        return view
    }
}

