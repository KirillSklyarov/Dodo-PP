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
    let addressStorage: AddressStorage
    let storageService: DataStorageService

    // MARK: - Init
    init(storageService: DataManager) {
        self.storage = storageService.deliveryStorage
        self.storageService = storageService.dataStorageService
        self.addressStorage = storageService.addressStorage
    }
}

// MARK: - Methods
extension DeliveryScreenFactory: DeliveryScreenFactoryProtocol {
    func makeDeliveryScreen() -> DeliveryVC {
        let viewModel = DeliveryViewModel(storageService: storageService, storage: storage)
        let view = DeliveryVC(viewModel: viewModel)
        return view
    }

    func makeChooseAddressScreen() -> ChooseAddressVC {
        let viewModel = ChooseAddressVM(storage: storage, storageService: storageService)
        let view = ChooseAddressVC(viewModel: viewModel)
        return view
    }

    func makeChoosePaymentMethodScreen() -> ChoosePaymentMethodVC {
        let viewModel = ChoosePaymentMethodVM(storage: storage)
        let view = ChoosePaymentMethodVC(viewModel: viewModel)
        return view
    }

    func makeEditAddressScreen() -> EditAddressViewController {
        let viewModel = EditAddressVM(storage: addressStorage)
        let view = EditAddressViewController(viewModel: viewModel)
        return view
    }

    func makeAddNewAddressScreen() -> AddNewAddressViewController {
        let viewModel = AddNewAddressVM(storage: addressStorage)
        let view = AddNewAddressViewController(viewModel: viewModel)
        return view
    }

    func makeFinalVCScreen() -> FinalVC {
        let viewModel = FinalViewModel(storageService: storageService)
        let view = FinalVC(viewModel: viewModel)
        return view
    }
}
