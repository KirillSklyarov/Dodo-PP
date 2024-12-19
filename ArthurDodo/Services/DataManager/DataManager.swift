import Foundation

struct DataManager {

    // MARK: - Module storages
    let profileStorage = ProfileStorage()
    let addressStorage = AddressStorage()
    let cartStorage = CartStorage()
    let deliveryStorage = DeliveryStorage()
    let mainStorage = MainStorage()
    let featureToggleStorage = FeatureToggleStorage()

    let dataStorageService: DataStorageService

    init () {
        dataStorageService = DataStorageService(profileStorage: profileStorage, addressStorage: addressStorage, cartStorage: cartStorage, mainStorage: mainStorage, deliveryStorage: deliveryStorage)
        deliveryStorage.setStorageService(dataStorageService)
        mainStorage.setStorageService(dataStorageService)
    }
}
