import Foundation

protocol PromoStorageProtocol: AnyObject {
    func setSelectedPromo(_ promo: Promo)
    func getSelectedPromo() -> Promo?
}

protocol ProfileStorageProtocol: PromoStorageProtocol {
    func setUserData(_ user: User)
    func getUserData() -> User?
    func getUserAddresses() -> [Address]?
    func isUserDataLoaded() -> Bool
    
    func setPromo(_ promos: [Promo])
    func getPromo() -> [Promo]
}

// Хранилище данных пользователя (фио, телефон, кол-во додокоинов и проч), а также акции, которые есть на экране профиля
final class ProfileStorage {

    // MARK: - Properties
    private var fetchedUserData: User?
    private var fetchedPromo: [Promo] = []
    private var selectedPromo: Promo?
}

// MARK: - Methods
extension ProfileStorage: ProfileStorageProtocol {
    // Получаем личные данные
    func setUserData(_ user: User) {
        fetchedUserData = user
    }

    // Отдаем личные данные
    func getUserData() -> User? {
        fetchedUserData
    }

    // Отдаем адреса юзера
    func getUserAddresses() -> [Address]? {
        fetchedUserData?.address
    }

    // Проверяем были ли ранее загружены данные
    func isUserDataLoaded() -> Bool {
        fetchedUserData != nil
    }

    // Отдаем кол-во додокоинов у юзера
    func getDodoCoins() -> Int {
        fetchedUserData?.dodoCoins ?? 0
    }

    // Устанавливаем выбранную акцию
    func setSelectedPromo(_ promo: Promo) {
        selectedPromo = promo
    }

    // Забираем выбранную акцию
    func getSelectedPromo() -> Promo? {
        selectedPromo
    }
}

// MARK: - Promo
extension ProfileStorage {
    // Получаем промо (коллекция "Акции" в корзине и в профиле)
    func setPromo(_ promo: [Promo]) {
        fetchedPromo = promo
    }

    // Возвращает загруженные акции
    func getPromo() -> [Promo] {
        fetchedPromo
    }
}
