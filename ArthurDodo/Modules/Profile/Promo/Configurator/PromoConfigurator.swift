
final class PromoConfigurator {
    // MARK: - Properties
    private let storage: PromoStorageProtocol

    // MARK: - Init
    init(storage: PromoStorageProtocol) {
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> PromoViewController {
        let router = PromoRouter()
        let presenter = PromoPresenter(storage: storage, router: router)
        let view = PromoViewController(output: presenter)

        presenter.view = view
        router.view = view

        return view
    }
}
