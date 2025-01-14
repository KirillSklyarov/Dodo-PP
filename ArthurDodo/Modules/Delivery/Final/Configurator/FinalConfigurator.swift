final class FinalConfigurator {
    // MARK: - Properties
    private let storageService: DataStorageService

    // MARK: - Init
    init(storageService: DataStorageService) {
        self.storageService = storageService
    }

    // MARK: - Methods
    func configure() -> FinalViewController {
        let presenter = FinalPresenter(storageService: storageService)
        let view = FinalViewController(output: presenter)

        presenter.view = view

        return view
    }
}
