final class EditItemConfigurator {
    // MARK: - Properties
    private let storage: CartStorage

    // MARK: - Init
    init(storage: CartStorage) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> EditItemViewController {
        let presenter = EditItemPresenter(storage: storage)
        let view = EditItemViewController(output: presenter)

        presenter.view = view

        return view
    }
}
