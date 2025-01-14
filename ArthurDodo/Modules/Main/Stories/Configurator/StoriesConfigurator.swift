import Foundation

final class StoriesConfigurator {
    // MARK: - Properties
    private let storage: MainStorage
    private let indexPath: IndexPath

    // MARK: - Init
    init(storage: MainStorage, indexPath: IndexPath) {
        self.storage = storage
        self.indexPath = indexPath
    }

    // MARK: - Methods
    func configure() -> StoriesViewController {
        let presenter = StoriesPresenter(storage: storage, indexPath: indexPath)
        let view = StoriesViewController(output: presenter)

        presenter.view = view

        return view
    }
}
