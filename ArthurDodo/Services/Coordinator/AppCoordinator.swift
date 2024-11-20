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
        mainCoordinator.onShowCart = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            startCartFlow()
            removeChild(mainCoordinator)
        }

        mainCoordinator.onShowProfile = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            showProfile()
            removeChild(mainCoordinator)
        }

        mainCoordinator.onShowAddress = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            showAddress()
            removeChild(mainCoordinator)
        }

        addChild(mainCoordinator) // Добавляем координатор в массив
        mainCoordinator.start() // Стартуем координатор
    }

    func showProfile() {
        let profileCoordinator = ProfileCoordinator(router: router, screenFactory: screenFactory) // Создаем координатор

        // Настраиваем замыкания: как только флоу профиля завершен, то начинаем новый главный поток
        profileCoordinator.onFlowFinished = { [weak self, weak profileCoordinator] in
            guard let self, let profileCoordinator else { return }
            startMainFlow() // Начинаем новый главный поток
            removeChild(profileCoordinator) // Удаляем координатор из массива
        }

        addChild(profileCoordinator) // Добавляем координатор в массив
        profileCoordinator.start() // Стартуем поток координатор в массив
    }

    func showAddress() {
        let addressCoordinator = AddressCoordinator(router: router, screenFactory: screenFactory)

        addressCoordinator.onAddressFlowFinished = { [weak self, weak addressCoordinator] in
            guard let self, let addressCoordinator else { return }
            startMainFlow()
            removeChild(addressCoordinator)
        }

        addChild(addressCoordinator)
        addressCoordinator.start()
    }

    func startCartFlow() {
        let cartCoordinator = CartCoordinator(router: router, screenFactory: screenFactory)

        // Если корзину закрываем, то стартуем главный поток
        cartCoordinator.onCartDismissed = { [weak self, weak cartCoordinator] in
            guard let self, let cartCoordinator else { print("CartCoordinator not found"); return }
            startMainFlow()
            removeChild(cartCoordinator)
        }

        // Обрабатываем замыкание когда у нас завершается флоу корзины и мы переходим к флоу доставки и оплаты
        cartCoordinator.onFinishFlow = { [weak self, weak cartCoordinator] in
            guard let self, let cartCoordinator else { print("CartCoordinator not found"); return }
            startDeliveryFlow() // Переходим на экран доставки (оплаты)
            removeChild(cartCoordinator) // Удаляем координатор из массива
        }

        addChild(cartCoordinator)
        cartCoordinator.start()
    }

    func startDeliveryFlow() {
        let deliveryCoordinator = DeliveryCoordinator(router: router, screenFactory: screenFactory)

        deliveryCoordinator.onFinishFlow = { [weak self, weak deliveryCoordinator] in
            guard let self, let deliveryCoordinator else { print("DeliveryCoordinator not found"); return }
            startMainFlow()
            removeChild(deliveryCoordinator)
        }

        addChild(deliveryCoordinator)
        deliveryCoordinator.start()
    }
}

// MARK: - Supporting methods
private extension AppCoordinator {
    // Добавляем координатор в массив координаторов, предварительно проверяем есть ли нет ли там уже ранее созданного такого же координатора
    func addChild(_ child: Coordinator) {
//        print("child: \(child)")
//        print("Array of child coordinators BEFORE ADDING: \(childCoordinators)")
        if !childCoordinators.contains(where: { $0 === child }) {
            childCoordinators.append(child)
        }
//        print("Array of child coordinators AFTER ADDING: \(childCoordinators)")
    }

    // Удаляем координатор из массива координаторов (здесь важно использовать ===, чтобы быть уверенным, что удаляется именно этот объект из памяти)
    func removeChild(_ child: Coordinator) {
//        print("child: \(child)")
//        print("Array of coordinators BEFORE REMOVING: \(childCoordinators)")
        childCoordinators.removeAll { $0 === child }
//        print("Array of coordinators AFTER REMOVING: \(childCoordinators)")
    }

//    func getMainCoordinator() -> MainCoordinator? {
//        guard let mainCoordinator = childCoordinators.first(where: { $0 is MainCoordinator }) as? MainCoordinator else { print("mainCoordinator not found"); return nil}
//        return mainCoordinator
//    }
}
