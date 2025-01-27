
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
        let presenter = PersonalPresenter(storage: storage)
        let view = PersonalViewController(output: presenter)

        presenter.view = view

        return view
    }
}
