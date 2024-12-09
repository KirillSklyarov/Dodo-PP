import Foundation

// MARK: - User Addresses
final class AddressStorage {

    private var fetchedUserData: User?
    private var editingAddress: Address? // В этой переменной лежит адрес, который редактируется

    // Временное решение, потом нужно переделать
    func setFetchedUserData(_ fetchedUserData: User) {
        self.fetchedUserData = fetchedUserData
    }

    // Принимаем редактируемый адрес
    func setEditingAddress(_ editingAddress: Address) {
        self.editingAddress = editingAddress
    }

    // Отдаем редактируемый адрес
    func getEditingAddress() -> Address? {
        editingAddress
    }

    // Проверяем были ли ранее загружены данные
    func isUserDataLoaded() -> Bool {
        fetchedUserData != nil
    }

    // Отправляем новый адрес в хранилище
    func updateAddressesAfterEdition(correctAddress: Address) {
        var deleteOldAddress = fetchedUserData?.address.filter { $0.addressId != correctAddress.addressId }
        deleteOldAddress?.append(correctAddress)
        guard let deleteOldAddress else { return }
        fetchedUserData?.address = deleteOldAddress
    }

    // Если данные юзера еще не были запрошены (то есть fetchedUserData == nil), то возвращаем true, в противном случае возвращаем false
    func isAddressesEmpty() -> Bool {
        return fetchedUserData == nil ? true : false
    }

    func getMainAddress() -> Address? {
        return fetchedUserData?.address.first(where: \.isMain)
    }

    func getAddresses() -> [Address] {
        guard let fetchedUserData else { print("fetchedUserData is nil"); return [] }
        return fetchedUserData.address
    }

    // Мы обнуляем для всех isMain и назначаем для нового, и потом сортируем чтобы isMain был первым
    func setNewMainAddress(_ newMainAddressName: String) {
        guard let fetchedUserData else { print("fetchedUserData is nil"); return }
        let addresses = fetchedUserData.address
        let newAddresses = addresses.map { address in
            var newAddress = address
            newAddress.isMain = (newAddress.name == newMainAddressName)
            return newAddress
        }
        self.fetchedUserData?.address = newAddresses.sortedMainFirst()
    }

    // Получаем кол-во адресов у юзера
    func getCountOfAddresses() -> Int {
        guard let fetchedUserData else { return 0 }
        return fetchedUserData.address.count
    }

    // Добавляем адрес в список адресов (но только в хранилище)
    func addAddress(_ address: Address) {
        self.fetchedUserData?.address.append(address)
    }
}
