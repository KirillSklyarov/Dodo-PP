import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

// Этот класс отвечает за создание экранов и навигацию внутри приложения. Класс использует помощников по блокам: главный экран, профиль, корзина, адреса.
final class AppCoordinator: Coordinator {

    // MARK: - Properties
    var navigationController: UINavigationController
    private let storage: DataStorage
    private var mainCoordinator: MainCoordinator?

    // MARK: - Init
    init(navigationController: UINavigationController, storage: DataStorage) {
        self.navigationController = navigationController
        self.storage = storage
    }

    func start() {
        let mainCoordinator = MainCoordinator(storage: storage, navigationController: navigationController)
        self.mainCoordinator = mainCoordinator
        mainCoordinator.start()
    }
}
