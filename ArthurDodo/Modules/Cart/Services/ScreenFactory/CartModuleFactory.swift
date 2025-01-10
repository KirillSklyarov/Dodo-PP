import Foundation

protocol CartModuleFactoryProtocol: AnyObject {
    func makeCartModule() -> CartViewController
    func makeEditItemModule() -> EditProductViewController
    func makePromoModule() -> PromoViewController
}

// Фабрика экранов модуля корзины
final class CartModuleFactory {

    let storage: CartStorage
    let storageService: DataStorageService

    init(dataManager: DataManager) {
        self.storage = dataManager.cartStorage
        self.storageService = dataManager.dataStorageService
    }
}

// MARK: - Methods
extension CartModuleFactory: CartModuleFactoryProtocol {
    func makeCartModule() -> CartViewController {
        let configurator = CartConfigurator(storage: storage, storageService: storageService)
        return configurator.configure()
    }

    func makeEditItemModule() -> EditProductViewController {
        let viewModel = EditItemViewModel(storage: storage)
        let view = EditProductViewController(viewModel: viewModel)
        return view
    }

    func makePromoModule() -> PromoViewController {
        let configurator = PromoConfigurator(storage: storage)
        return configurator.configure()
    }
}
