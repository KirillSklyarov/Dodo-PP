import UIKit

// Класс фабрика экранов отвечает за создание экранов
final class CoordinatorFactory {
    // MARK: - Properties
    private let router: Router
    private let screenFactory: ScreenFactory
    private let storage: DataStorage

    // MARK: - Init
    init(router: Router, screenFactory: ScreenFactory, storage: DataStorage) {
        self.router = router
        self.screenFactory = screenFactory
        self.storage = storage
    }
}

// MARK: - Methods
extension CoordinatorFactory {
    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(coordinatorFactory: self)
    }

    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(router: router, screenFactory: screenFactory, storage: storage)
    }

    func makeProfileCoordinator() -> ProfileCoordinator {
        return ProfileCoordinator(router: router, screenFactory: screenFactory)
    }

    func makeAddressCoordinator() -> AddressCoordinator {
        return AddressCoordinator(router: router, screenFactory: screenFactory)
    }

    func makeCartCoordinator() -> CartCoordinator {
        return CartCoordinator(router: router, screenFactory: screenFactory)
    }

    func makeDeliveryCoordinator() -> DeliveryCoordinator {
        return DeliveryCoordinator(router: router, screenFactory: screenFactory)
    }
}
