import Foundation

protocol CartScreenFactoryProtocol: AnyObject {
    func makeCartScreen() -> CartViewController
    func makeEditProductScreen() -> EditProductViewController
    func makePromoModule() -> PromoViewController
}

// Фабрика экранов модуля корзины
final class CartScreenFactory {

    let storage: CartStorage
    let storageService: DataStorageService

    init(dataManager: DataManager) {
        self.storage = dataManager.cartStorage
        self.storageService = dataManager.dataStorageService
    }
}

// MARK: - Methods
extension CartScreenFactory: CartScreenFactoryProtocol {
    func makeCartScreen() -> CartViewController {
        let viewModel = CartViewModel(storage: storage, storageService: storageService)
        let view = CartViewController(viewModel: viewModel)
        return view
    }

    func makeEditProductScreen() -> EditProductViewController {
        let viewModel = EditItemViewModel(storage: storage)
        let view = EditProductViewController(viewModel: viewModel)
        return view
    }

    func makePromoModule() -> PromoViewController {
        let configurator = PromoConfigurator(storage: storage)
        return configurator.configure()
    }
}
