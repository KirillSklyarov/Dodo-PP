import Foundation

final class DeliveryScreenFactory {

    let storage: DeliveryStorage
    let storageService: DataStorage

    init(storage: DeliveryStorage, storageService: DataStorage) {
        self.storage = storage
        self.storageService = storageService
    }
}

// MARK: - Methods
extension DeliveryScreenFactory {
    func makeDeliveryScreen() -> DeliveryVC {
        let presenter = DeliveryPresenter(storageService: storageService, storage: storage)
        let view = DeliveryVC(presenter: presenter)
        presenter.view = view
        return view
    }

//    func makeEditProductScreen() -> EditProductViewController {
//        let presenter = EditProductPresenter(storage: storage)
//        let view = EditProductViewController(presenter: presenter)
//        presenter.view = view
//        return view
//    }
//
//    func makePromoScreen(_ offer: Promo) -> PromoViewController {
//        return PromoViewController(with: offer)
//    }
}
