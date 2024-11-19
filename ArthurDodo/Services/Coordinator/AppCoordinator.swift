import UIKit

protocol Coordinator: AnyObject {
    func start()
}

// Этот класс отвечает за создание экранов и навигацию внутри приложения. Класс использует помощников по блокам: главный экран, профиль, корзина, адреса.
final class AppCoordinator: Coordinator {

    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }

    // Делаем такую обертку, чтобы AppCoordinator соответствовал протоколу Coordinator
    func start() {
        startMainFlow()
    }

    func startMainFlow() {
        let mainCoordinator = MainCoordinator(router: router, screenFactory: screenFactory) // Создаем экран

        // Настраиваем замыкания
        mainCoordinator.onShowCart = { [weak self] in
            self?.showCart()
        }

        mainCoordinator.onShowProfile = { [weak self] mainVC in
            self?.showProfile()
        }

        mainCoordinator.onShowAddress = { [weak self] mainVC in
            self?.showAddress(mainVC)
        }

        addChild(mainCoordinator) // Добавляем координатор в массив
        mainCoordinator.start() // Стартуем координатор
    }

    func showCart() {
        let cartCoordinator = CartCoordinator(router: router, screenFactory: screenFactory)

        cartCoordinator.onCartDismissed = { [weak self] in
            self?.start()
        }

        // Обрабатываем замыкание когда у нас завершается флоу корзины (то есть когда весь заказ оформлен и оплачен)
        cartCoordinator.onFinishFlow = { [weak self] in
            guard let self else { print("mainCoordinator not found"); return }
            startMainFlow() // Переходим на главный экран
            removeChild(cartCoordinator) // Удаляем координатор из массива
        }

        addChild(cartCoordinator)
        cartCoordinator.start()
    }

    func showProfile() {
        let profileCoordinator = ProfileCoordinator(router: router, screenFactory: screenFactory) // Создаем координатор

        // Настраиваем замыкания: как только флоу профиля завершен, то начинаем новый главный поток
        profileCoordinator.onProfileFlowFinished = { [weak self] in
            guard let self else { return }
            startMainFlow() // Начинаем новый главный поток
            removeChild(profileCoordinator) // Удаляем координатор из массива
        }

        addChild(profileCoordinator) // Добавляем координатор в массив
        profileCoordinator.start() // Стартуем поток координатор в массив
    }

    func showAddress(_ parentVC: UIViewController) {
        let addressCoordinator = AddressCoordinator(router: router, screenFactory: screenFactory)

        addressCoordinator.onAddressFlowFinished = { [weak self] in
            guard let self else { return }
            startMainFlow()
            removeChild(addressCoordinator)
        }

        addChild(addressCoordinator)
        addressCoordinator.start()
    }
}

// MARK: - Supporting methods
private extension AppCoordinator {
    // Добавляем координатор в массив координаторов
    func addChild(_ child: Coordinator) {
        childCoordinators.append(child)
    }

    // Удаляем координатор из массива координаторов (здесь важно использовать ===, чтобы быть уверенным, что удаляется именно этот объект из памяти)
    func removeChild(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }

//    func mainVCUpdateUI() {
//        let mainCoordinator = getMainCoordinator()
//        mainCoordinator?.updateUI()
//    }

    func getMainCoordinator() -> MainCoordinator? {
        guard let mainCoordinator = childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator else { print("mainCoordinator not found"); return nil}
        return mainCoordinator
    }
}
