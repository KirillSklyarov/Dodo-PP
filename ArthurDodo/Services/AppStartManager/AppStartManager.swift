import UIKit

final class AppStartManager {

    // MARK: - Properties
    let networkService: NetworkService
    let storage: DataManager
    let featureToggleService: FeatureToggleService
    let screenFactory: ScreenFactory
    let router: Router
    let coordinatorFactory: CoordinatorFactory
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // MARK: - Init
    init(networkService: NetworkService, storage: DataManager, featureToggleService: FeatureToggleService, screenFactory: ScreenFactory, router: Router, coordinatorFactory: CoordinatorFactory) {
        self.networkService = networkService
        self.storage = storage
        self.featureToggleService = featureToggleService
        self.screenFactory = screenFactory
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
}

// MARK: - Public methods
extension AppStartManager {
    // Принимаем окно из SceneDelegate
    func setWindow(_ window: UIWindow?) {
        self.window = window
    }

    // Запускаем приложение
    func startApp() {
        startAppBasedOnScheme()
    }

    func getAppCoordinator() -> AppCoordinator? {
        appCoordinator
    }
}

// MARK: - Key methods
private extension AppStartManager {
    // В зависимости от схемы либо запускаем showFeatureToggles (в режиме Debug), либо запускаем standardUserAppStart (в режиме релиза)
    func startAppBasedOnScheme() {
#if DEBUG
        showFeatureToggles()
#else
        standardUserAppStart()
#endif
    }
}

// MARK: - Debug mode app start
private extension AppStartManager {
    // В debug mode мы сначала у featureToggleService запрашиваем фичи, потом показываем экран с фичами
    func showFeatureToggles() {
        Task {
            await featureToggleService.fetchAllFeatures()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                showFeatureTogglesVC()
            }
        }
    }

    //  Показываем экран с фичам, при нажатии на кнопку на экране фичей стартуем стандартный режим приложения
    func showFeatureTogglesVC() {
        let featureToggleVC = screenFactory.makeFeatureTogglesScreen()

        featureToggleVC.onStartButtonTapped = { [weak self] in
            guard let self else { return }
            standardUserAppStart()
        }

        window?.rootViewController = featureToggleVC
        window?.makeKeyAndVisible()
    }
}

// MARK: - Release mode app start
private extension AppStartManager {
    // В release mode запускаем устанавливаем навигацию как root, и стартуем приложение в стандартном режиме
    func standardUserAppStart() {
        window?.rootViewController = router.setRootNavigation()
        window?.makeKeyAndVisible()
        standardStartApp()
    }

    // Сначала запрашиваем все данные у сервера, потом на главном потоке делаем appCoordinator и стартуем приложение
    func standardStartApp() {
        Task {
            await fetchAllData()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                appCoordinator = coordinatorFactory.makeAppCoordinator()
                appCoordinator?.start()
            }
        }
    }
}

// MARK: - Fetch data
private extension AppStartManager {
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
                await self?.fetchCatalog()
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

// MARK: - Supporting methods
private extension AppStartManager {
    // Получаем данные пользователя с сервера и отправляем их в хранилище
    func fetchUserData() async {
        do {
            let userData = try await networkService.fetchUserData()
            storage.profileStorage.setUserData(userData)
            storage.addressStorage.setFetchedUserData(userData)
            print("User data fetched")
        } catch {
            print("User Data fetch error:: \(error)")
        }
    }

    // Получаем сторисы с сервера и отправляем их в хранилище
    func fetchStories() async {
        do {
            let stories = try await networkService.fetchStories()
            storage.dataStorageService.setStories(stories)
            print("Stories fetched")
        } catch {
            print("Stories fetch error: \(error)")
        }
    }

    // Получаем каталог с сервера и отправляем его в хранилище
    func fetchCatalog() async {
        do {
            let items = try await networkService.fetchItems()
            storage.dataStorageService.setItems(items)
            print("Items fetched")
        } catch {
            print("Items fetch error: \(error)")
        }
    }

    // Получаем акции с сервера и отправляем их в хранилище (в данном случае в хранилище профиля)
    func fetchPromo() async {
        do {
            let promo = try await networkService.fetchPromo()
            storage.profileStorage.setPromo(promo)
            storage.cartStorage.setPromo(promo)
            print("Promo fetched")
        } catch {
            print("Promo fetch error: \(error)")
        }
    }

    // Получаем начинки с сервера и отправляем их в хранилище
    func fetchToppings() async {
        do {
            let toppings = try await networkService.fetchToppings()
            storage.mainStorage.setToppings(toppings)
            print("Toppings fetched")
        } catch {
            print("Toppings fetch error: \(error)")
        }
    }
}
