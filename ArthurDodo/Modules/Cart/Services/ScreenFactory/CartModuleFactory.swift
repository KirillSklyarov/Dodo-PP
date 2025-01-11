import UIKit

protocol CartModuleFactoryProtocol: BaseModuleFactory where
    Module == CartModule,
    ErrorType == CartErrorType {
}

enum CartModule {
    case cart
    case editProduct
    case promo
}

enum CartErrorType {
    case cartError
    case editItemError
}

// Фабрика экранов модуля корзины
final class CartModuleFactory {
    // MARK: - Properties
    let storage: CartStorage
    let storageService: DataStorageService

    // MARK: - Init
    init(dataManager: DataManager) {
        self.storage = dataManager.cartStorage
        self.storageService = dataManager.dataStorageService
    }
}

// MARK: - Methods
extension CartModuleFactory: CartModuleFactoryProtocol {
    // Создаем модули
    func makeModule(for module: CartModule) -> UIViewController {
        switch module {
        case .cart: return makeCartModule()
        case .editProduct: return makeEditItemModule()
        case .promo: return makePromoModule()
        }
    }

    // Создаем алерты с ошибками
    func makeErrorAlert(for errorAlert: CartErrorType, completion: (() -> Void)?) -> UIAlertController {
        switch errorAlert {
        case .cartError: return makeCartErrorAlert() { completion?() }
        case .editItemError: return makeEditItemErrorAlert() { completion?() }
        }
    }
}

// MARK: - Supporting methods
private extension CartModuleFactory {
    func makeCartModule() -> CartViewController {
        let configurator = CartConfigurator(storage: storage, storageService: storageService)
        return configurator.configure()
    }

    func makeEditItemModule() -> EditItemViewController {
        let configurator = EditItemConfigurator(storage: storage)
        return configurator.configure()
    }

    func makePromoModule() -> PromoViewController {
        let configurator = PromoConfigurator(storage: storage)
        return configurator.configure()
    }

    func makeCartErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.cart) {
            completion?()
        }
    }

    func makeEditItemErrorAlert(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.editItem) {
            completion?()
        }
    }
}
