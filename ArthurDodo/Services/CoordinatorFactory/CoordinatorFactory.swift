import UIKit

enum appCoordinator {
    case app
    case main
    case profile
    case address
    case cart
    case delivery
}

// Класс "Фабрика координатором" отвечает за создание координаторов
final class CoordinatorFactory {
    // MARK: - Properties
    private let router: Router
    private let moduleFactory: ModuleFactory
    private let storage: DataManager

    // MARK: - Init
    init(router: Router, moduleFactory: ModuleFactory, storage: DataManager) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.storage = storage
    }

    func makeCoordinator<T: Coordinator>(for route: appCoordinator) -> T {
        let coordinator: Coordinator =
        switch route {
        case .app: makeAppCoordinator()
        case .main:  makeMainCoordinator()
        case .profile:  makeProfileCoordinator()
        case .address:  makeAddressCoordinator()
        case .cart:  makeCartCoordinator()
        case .delivery:  makeDeliveryCoordinator()
        }

        guard let typedCoordinator = coordinator as? T else { fatalError("Wrong coordinator type") }
        return typedCoordinator
    }
}

// MARK: - Methods
private extension CoordinatorFactory {
    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(coordinatorFactory: self)
    }

    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(router: router, moduleFactory: moduleFactory.mainModuleFactory, storage: storage.featureToggleStorage)
    }

    func makeProfileCoordinator() -> ProfileCoordinator {
        return ProfileCoordinator(moduleFactory: moduleFactory.profileModuleFactory, router: router)
    }

    func makeAddressCoordinator() -> AddressCoordinator {
        return AddressCoordinator(router: router, screenFactory: moduleFactory.addressModuleFactory)
    }

    func makeCartCoordinator() -> CartCoordinator {
        return CartCoordinator(router: router, screenFactory: moduleFactory.cartModuleFactory)
    }

    func makeDeliveryCoordinator() -> DeliveryCoordinator {
        return DeliveryCoordinator(moduleFactory: moduleFactory.deliveryModuleFactory as! DeliveryModuleFactory, router: router)
    }
}
