
final class ItemDetailsConfigurator {
    // MARK: - Properties
    private let storage: MainStorage

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> ItemDetailsViewController {
        let presenter = ItemDetailsPresenter(storage: storage)
        let view = ItemDetailsViewController(output: presenter)

        presenter.view = view

        return view
    }
}

