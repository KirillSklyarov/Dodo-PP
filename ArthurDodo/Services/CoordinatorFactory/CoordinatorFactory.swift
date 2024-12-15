import UIKit

// Класс "Фабрика координатором" отвечает за создание координаторов
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
        return MainCoordinator(router: router, screenFactory: screenFactory.mainScreenFactory, storage: storage)
    }

    func makeProfileCoordinator() -> ProfileCoordinator {
        return ProfileCoordinator(router: router, screenFactory: screenFactory.profileScreenFactory)
    }

    func makeAddressCoordinator() -> AddressCoordinator {
        return AddressCoordinator(router: router, screenFactory: screenFactory.addressScreenFactory)
    }

    func makeCartCoordinator() -> CartCoordinator {
        return CartCoordinator(router: router, screenFactory: screenFactory.cartScreenFactory)
    }

    func makeDeliveryCoordinator() -> DeliveryCoordinator {
        return DeliveryCoordinator(router: router, screenFactory: screenFactory)
    }
}
