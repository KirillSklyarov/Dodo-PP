
final class PersonalConfigurator {
    // MARK: - Properties
    private let moduleFactory: ProfileModuleFactory
    private let storage: ProfileStorage

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory, storage: ProfileStorage) {
        self.moduleFactory = moduleFactory
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> PersonalViewController {
        let router = PersonalRouter(moduleFactory: moduleFactory)
        let presenter = PersonalPresenter(storage: storage, router: router)
        let view = PersonalViewController(output: presenter)

        presenter.view = view
        router.view = view

        return view
    }
}
