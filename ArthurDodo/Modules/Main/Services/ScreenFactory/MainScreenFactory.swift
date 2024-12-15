import UIKit

protocol MainScreenFactoryProtocol: AnyObject {
    func makeMainScreen() -> MainViewController
    func makeProductDetailsScreen() -> ProductDetailsViewController
    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC
    func makeAlertScreen(_ type: AlertType) -> UIAlertController
}

// Фабрика экранов модуля главного экрана
final class MainScreenFactory {

    // MARK: - Properties
    private let storage: MainStorage

    // MARK: - Init
    init(storage: MainStorage) {
        self.storage = storage
    }
}

// MARK: - Methods
extension MainScreenFactory: MainScreenFactoryProtocol {
    func makeMainScreen() -> MainViewController {
        let presenter = MainPresenter(storage: storage)
        let view = MainViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeProductDetailsScreen() -> ProductDetailsViewController {
        let presenter = ProductDetailsPresenter(storage: storage)
        let view = ProductDetailsViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC {
        let stories = storage.getFetchedStories()
        return StoriesVC(indexPath: indexPath, stories: stories)
    }

    func makeAlertScreen(_ type: AlertType) -> UIAlertController {
        return AppAlert.create(type)
    }
}
