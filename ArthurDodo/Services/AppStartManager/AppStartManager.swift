import UIKit

final class AppStartManager {

    // MARK: - Properties
    let networkService: NetworkService
    let storage: DataManager
    let featureToggleService: FeatureToggleService
    let screenFactory: ModuleFactory
    let router: Router
    let coordinatorFactory: CoordinatorFactory
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // MARK: - Init
    init(networkService: NetworkService, storage: DataManager, featureToggleService: FeatureToggleService, screenFactory: ModuleFactory, router: Router, coordinatorFactory: CoordinatorFactory) {
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
        debugStartFlow()
#else
        commonStartApp()
#endif
    }

    // В режиме дебага мы включаем featureToggle и только после этого мы делаем стандартный запуск приложения
    func debugStartFlow() {
        showFeatureToggles()
    }

    // В режиме релиза мы делаем стандартный запуск приложения
    func releaseStartFlow() {
        commonStartApp()
    }
}

// MARK: - Debug mode app start
private extension AppStartManager {
    // Мы сначала запрашиваем фичи, потом показываем экран с фичами
    func showFeatureToggles() {
        Task {
            await featureToggleService.fetchAllFeatures()
            showFeatureTogglesVC()
        }
    }

    //  Показываем экран с фичам, при нажатии на кнопку на экране фичей стартуем стандартный режим приложения
    func showFeatureTogglesVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            showScreen(screenType: .featureToggle)
        }
    }
}

// MARK: - Release mode app start
private extension AppStartManager {
    // Сначала запрашиваем все данные у сервера, потом показываем стартовый экран и начинаем стандартный показ приложения
    func commonStartApp() {
        fetchData()
        showAppStartVC()
    }

    // Показываем стартовый экран и после всей анимации переходим в обычный старт приложения
    func showAppStartVC() {
        showScreen(screenType: .appStart)
        startAppCoordinator()
    }

    // Запрашиваем все данные у сервера
    func fetchData() {
        Task { await fetchAllData() }
    }

    // Создаем appCoordinator и стартуем приложение (тут идет создание главного экрана, но не показывает его)
    func startAppCoordinator() {
        appCoordinator = coordinatorFactory.makeAppCoordinator()
        appCoordinator?.start()
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

// MARK: - Show Screen
private extension AppStartManager {
    func showScreen(screenType: AppStartScreenType) {
        switch screenType {
        case .featureToggle:
            let featureToggleVC = screenFactory.makeFeatureTogglesScreen()

            featureToggleVC.onStartButtonTapped = { [weak self] in
                self?.commonStartApp()
            }

            window?.rootViewController = featureToggleVC
            window?.makeKeyAndVisible()
        case .appStart:
            let appStartVC = screenFactory.makeAppStartScreen()
            window?.rootViewController = appStartVC
            window?.makeKeyAndVisible()

            appStartVC.onStartAppScreenFinished = { [weak self] in
                self?.showMainScreenAppCoordinator()
            }
        case .appCoordinator:
            window?.rootViewController = router.setRootNavigation()
            window?.makeKeyAndVisible()
        }
    }

    // Говорим appCoordinator показать главный экран
    func showMainScreenAppCoordinator() {
        showScreen(screenType: .appCoordinator)
        appCoordinator?.showMainScreen()
    }
}
