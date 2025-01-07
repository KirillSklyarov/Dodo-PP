
final class ProfileConfigurator {
    // MARK: - Properties
    private let moduleFactory: ProfileModuleFactory
    private let storage: ProfileStorage

    // MARK: - Init
    init(moduleFactory: ProfileModuleFactory, storage: ProfileStorage) {
        self.moduleFactory = moduleFactory
        self.storage = storage
    }

    // MARK: - Methods
    func configure() -> ProfileViewController {
        let view = ProfileViewController()
        let router = ProfileRouter(view: view, moduleFactory: moduleFactory)
        let presenter = ProfilePresenter(storage: storage, router: router, view: view)
        view.output = presenter

        return view
    }
}
