
final class PromoConfigurator {
    // MARK: - Properties
    private let storage: PromoStorageProtocol

    // MARK: - Init
    init(storage: PromoStorageProtocol) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> PromoViewController {
        let presenter = PromoPresenter(storage: storage)
        let view = PromoViewController(output: presenter)

        presenter.view = view

        return view
    }
}
