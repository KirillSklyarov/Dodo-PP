import Foundation

protocol DeliveryScreenFactoryProtocol: AnyObject {
    func makeDeliveryScreen() -> DeliveryVC
    func makeChooseAddressScreen() -> ChooseAddressVC
    func makeChoosePaymentMethodScreen() -> ChoosePaymentMethodVC
    func makeEditAddressScreen() -> EditAddressViewController
    func makeAddNewAddressScreen() -> AddNewAddressViewController
    func makeFinalVCScreen() -> FinalVC
}

// Фабрика экранов модуля Доставки и оплаты
final class DeliveryScreenFactory {

    // MARK: - Properties
    let storage: DeliveryStorage
    let storageService: DataStorage

    // MARK: - Init
    init(storageService: DataStorage) {
        self.storage = storageService.deliveryStorage
        self.storageService = storageService
    }
}

// MARK: - Methods
extension DeliveryScreenFactory: DeliveryScreenFactoryProtocol {
    func makeDeliveryScreen() -> DeliveryVC {
        let presenter = DeliveryPresenter(storageService: storageService, storage: storage)
        let view = DeliveryVC(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeChooseAddressScreen() -> ChooseAddressVC {
        let presenter = ChooseAddressPresenter(storage: storage, storageService: storageService)
        let view = ChooseAddressVC(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeChoosePaymentMethodScreen() -> ChoosePaymentMethodVC {
        let presenter = ChoosePaymentMethodPresenter(storage: storage)
        let view = ChoosePaymentMethodVC(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeEditAddressScreen() -> EditAddressViewController {
        let addressStorage = storageService.addressStorage
        let presenter = EditAddressPresenter(storage: addressStorage)
        let view = EditAddressViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        let addressStorage = storageService.addressStorage
        let presenter = AddNewAddressPresenter(storage: addressStorage)
        let view = AddNewAddressViewController(presenter: presenter)
        presenter.view = view
        return view
    }

    func makeFinalVCScreen() -> FinalVC {
        let presenter = FinalPresenter(storage: storage)
        let view = FinalVC(presenter: presenter)
        presenter.view = view
        return view
    }
}
