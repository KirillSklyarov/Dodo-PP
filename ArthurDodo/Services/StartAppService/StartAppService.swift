import Foundation

final class StartAppService {

    var networkService: NetworkService
    var storage: DataStorage

    init(networkService: NetworkService, storage: DataStorage) {
        self.networkService = networkService
        self.storage = storage
    }

    // Выполняется загрузка всех необходимых данных (личных данных юзера, сторисов, каталога, акций, топпингов). Важно: загрузка всех данных осуществляется параллельно, что ускоряет работу приложения (именно для этого используем TaskGroup).
    func fetchAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { [weak self] in
                await self?.fetchUserData()
            }

            group.addTask { [weak self] in
                await self?.fetchStories()
            }

            group.addTask { [weak self] in
                await self?.fetchItems()
            }

            group.addTask { [weak self] in
                await self?.fetchPromo()
            }

            group.addTask { [weak self] in
                await self?.fetchToppings()
            }
        }
        print("Все запросы выполнены")
    }
}

// MARK: - Fetch methods
private extension StartAppService {
    // Получаем данные пользователя с сервера и отправляем их в хранилище
    func fetchUserData() async {
        do {
            let userData = try await networkService.fetchUserData()
            storage.setUserData(userData)
            print("User data fetched")
        } catch {
            print("User Data fetch error:: \(error)")
        }
    }

    // Получаем сторисы с сервера и отправляем их в хранилище
    func fetchStories() async {
        do {
            let stories = try await networkService.fetchStories()
            storage.setStories(stories)
            print("Stories fetched")
        } catch {
            print("Stories fetch error: \(error)")
        }
    }

    // Получаем каталог с сервера и отправляем его в хранилище
    func fetchItems() async {
        do {
            let items = try await networkService.fetchItems()
            storage.setItems(items)
            print("Items fetched")
        } catch {
            print("Items fetch error: \(error)")
        }
    }

    // Получаем акции с сервера и отправляем их в хранилище
    func fetchPromo() async {
        do {
            let promo = try await networkService.fetchPromo()
            storage.setPromo(promo)
            print("Promo fetched")
        } catch {
            print("Promo fetch error: \(error)")
        }
    }

    // Получаем начинки с сервера и отправляем их в хранилище
    func fetchToppings() async {
        do {
            let toppings = try await networkService.fetchToppings()
            storage.setToppings(toppings)
            print("Toppings fetched")
        } catch {
            print("Toppings fetch error: \(error)")
        }
    }
}
