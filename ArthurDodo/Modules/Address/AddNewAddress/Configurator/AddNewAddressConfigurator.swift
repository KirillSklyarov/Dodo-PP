final class AddNewAddressConfigurator {
    // MARK: - Properties
    private let storage: AddressStorage

    // MARK: - Init
    init(storage: AddressStorage) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> AddNewAddressViewController {
        let presenter = AddNewAddressPresenter(storage: storage)
        let view = AddNewAddressViewController(output: presenter)

        presenter.view = view

        return view
    }
}
