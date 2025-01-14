final class AddressConfigurator {
    // MARK: - Properties
    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> AddressViewController {
        let presenter = AddressPresenter(storage: storage)
        let view = AddressViewController(output: presenter)

        presenter.view = view

        return view
    }
}

