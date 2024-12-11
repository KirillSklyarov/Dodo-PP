import Foundation

final class CartScreenFactory {

    let storage: CartStorage
    let storageService: DataStorage

    init(storage: CartStorage, storageService: DataStorage) {
        self.storage = storage
        self.storageService = storageService
    }
}

// MARK: - Methods
extension CartScreenFactory {
    func makeCartScreen() -> CartViewController {
        let presenter = CartPresenter(storage: storage, storageService: storageService)
        let view = CartViewController(presenter: presenter)
        presenter.view = view
        return view
    }

//    func makePromoScreen(_ offer: Promo) -> PromoViewController {
//        let presenter = PromoPresenter(storage: storage, offer: offer)
//        let view = PromoViewController(presenter: presenter)
//        presenter.view = view
//        return view
//    }
}
