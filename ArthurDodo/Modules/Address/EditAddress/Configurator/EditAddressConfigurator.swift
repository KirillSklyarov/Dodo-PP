final class EditAddressConfigurator {
    // MARK: - Properties
    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> EditAddressViewController {
        let presenter = EditAddressPresenter(storage: storage)
        let view = EditAddressViewController(output: presenter)

        presenter.view = view

        return view
    }
}
