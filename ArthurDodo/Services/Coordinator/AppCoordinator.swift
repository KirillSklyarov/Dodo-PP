import UIKit

protocol Coordinator: AnyObject {
    func start()
}

// Этот класс отвечает за создание экранов и навигацию внутри приложения. Класс использует помощников по блокам: главный экран, профиль, корзина, адреса.
final class AppCoordinator: Coordinator {

    // MARK: - Properties
    private let coordinatorFactory: CoordinatorFactory
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(coordinatorFactory: CoordinatorFactory) {
        self.coordinatorFactory = coordinatorFactory
    }

    deinit {
        print("AppCoordinator deinit")
    }

    // Делаем такую обертку, чтобы AppCoordinator соответствовал протоколу Coordinator
    func start() {
        startMainFlow()
    }
}

// MARK: - Main Flow
private extension AppCoordinator {
    func startMainFlow() {
        let mainCoordinator = coordinatorFactory.makeMainCoordinator() // Создаем координатор

        // Настраиваем замыкания
        mainCoordinator.onShowCart = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            startCartFlow()
            removeChild(mainCoordinator)
        }

        mainCoordinator.onShowProfile = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            startProfileFlow()
            removeChild(mainCoordinator)
        }

        mainCoordinator.onShowAddress = { [weak self, weak mainCoordinator] in
            guard let self, let mainCoordinator else { return }
            startAddressFlow()
            removeChild(mainCoordinator)
        }

        addChild(mainCoordinator) // Добавляем координатор в массив
        mainCoordinator.start() // Стартуем координатор
        print(childCoordinators)
    }
}

// MARK: - Profile Flow
private extension AppCoordinator {
    func startProfileFlow() {
        let profileCoordinator = coordinatorFactory.makeProfileCoordinator() // Создаем координатор

        // Настраиваем замыкания: как только флоу профиля завершен, то начинаем новый главный поток
        profileCoordinator.onFlowFinished = { [weak self, weak profileCoordinator] in
            guard let self, let profileCoordinator else { return }
            startMainFlow() // Начинаем новый главный поток
            removeChild(profileCoordinator) // Удаляем координатор из массива
        }

        addChild(profileCoordinator) // Добавляем координатор в массив
        profileCoordinator.start() // Стартуем поток координатор в массив

    }
}

// MARK: - Address Flow
private extension AppCoordinator {
    func startAddressFlow() {
        let addressCoordinator = coordinatorFactory.makeAddressCoordinator()

        addressCoordinator.onFlowFinished = { [weak self, weak addressCoordinator] in
            guard let self, let addressCoordinator else { return }
            startMainFlow()
            removeChild(addressCoordinator)
        }

        addChild(addressCoordinator)
        addressCoordinator.start()
    }
}

// MARK: - Cart Flow
private extension AppCoordinator {
    func startCartFlow() {
        let cartCoordinator = coordinatorFactory.makeCartCoordinator()

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
}

// MARK: - Delivery Flow
private extension AppCoordinator {
    func startDeliveryFlow() {
        let deliveryCoordinator = coordinatorFactory.makeDeliveryCoordinator()

        // Когда юзер нажал на кнопку закрыть в DeliveryFlow, то мы возвращаемся в корзину
        deliveryCoordinator.onDismissed = { [weak self, weak deliveryCoordinator] in
            guard let self, let deliveryCoordinator else { print("DeliveryCoordinator not found"); return }
            startCartFlow() // Стартуем флоу корзины
            removeChild(deliveryCoordinator) // Удаляем из массива координатор
        }

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
        if !childCoordinators.contains(where: { $0 === child }) {
            childCoordinators.append(child)
        }
    }

    // Удаляем координатор из массива координаторов (здесь важно использовать ===, чтобы быть уверенным, что удаляется именно этот объект из памяти)
    func removeChild(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
