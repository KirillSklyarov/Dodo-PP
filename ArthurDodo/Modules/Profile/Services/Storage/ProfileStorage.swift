import Foundation

// Хранилище данных пользователя (фио, телефон, кол-во додокоинов и проч), а также акции, которые есть на экране профиля
final class ProfileStorage {

    // MARK: - Properties
    private var fetchedUserData: User?
    private var fetchedPromo: [Promo] = []
}

// MARK: - Methods
extension ProfileStorage {
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
