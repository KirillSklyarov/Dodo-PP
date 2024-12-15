import Foundation

protocol CartScreenFactoryProtocol: AnyObject {
    func makeCartScreen() -> CartViewController
    func makeEditProductScreen() -> EditProductViewController
    func makePromoScreen(_ offer: Promo) -> PromoViewController
}

// Фабрика экранов модуля корзины
final class CartScreenFactory {

    let storage: CartStorage
    let storageService: DataStorage

    init(storageService: DataStorage) {
        self.storage = storageService.cartStorage
        self.storageService = storageService
    }
}

// MARK: - Methods
extension CartScreenFactory: CartScreenFactoryProtocol {
    func makeCartScreen() -> CartViewController {
        let presenter = CartPresenter(storageService: storageService)
        let view = CartViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeEditProductScreen() -> EditProductViewController {
        let presenter = EditProductPresenter(storage: storage)
        let view = EditProductViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makePromoScreen(_ offer: Promo) -> PromoViewController {
        return PromoViewController(with: offer)
    }
}
