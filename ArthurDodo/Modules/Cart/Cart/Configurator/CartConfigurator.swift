final class CartConfigurator {
    // MARK: - Properties
    private let storageService: DataStorageService
    private let storage: CartStorage

    // MARK: - Init
    init(storage: CartStorage, storageService: DataStorageService) {
        self.storage = storage
        self.storageService = storageService
    }

    // MARK: - Methods
    func configure() -> CartViewController {
        let presenter = CartPresenter(storage: storage, storageService: storageService)
        let view = CartViewController(output: presenter)

        presenter.view = view

        return view
    }
}
