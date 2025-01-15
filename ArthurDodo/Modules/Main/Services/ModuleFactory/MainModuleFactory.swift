import UIKit

protocol MainModuleFactoryProtocol: BaseModuleFactory where Module == MainModule, ErrorType == MainModuleError  {
}

enum MainModule {
    case main
    case itemDetails
    case stories(IndexPath)
}

enum MainModuleError {
    case main
    case itemDetails
    case stories
}

// Фабрика экранов модуля главного экрана
final class MainModuleFactory {

    // MARK: - Properties
    private let storage: MainStorage
    private let featureToggleService: FeatureToggleService

    // MARK: - Init
    init(storage: MainStorage, featureToggleService: FeatureToggleService) {
        self.storage = storage
        self.featureToggleService = featureToggleService
    }
}

extension MainModuleFactory: MainModuleFactoryProtocol {
    func makeModule(for module: MainModule) -> UIViewController {
        switch module {
        case .main: return makeMainModule()
        case .itemDetails: return makeItemDetailsScreen()
        case .stories(let indexPath): return makeStoriesModule(indexPath: indexPath)
        }
    }

    func makeErrorAlert(for errorAlert: MainModuleError, completion: (() -> Void)?) -> UIAlertController {
        switch errorAlert {
        case .main: return makeMainAlertScreen(completion: completion)
        case .itemDetails: return makeItemDetailsAlertScreen(completion: completion)
        case .stories: return makeStoriesAlertScreen(completion: completion)
        }
    }
}

// MARK: - Creating modules
extension MainModuleFactory {
    func makeMainModule() -> MainViewController {
        let configurator = MainConfigurator(storage: storage, featureTogglesService: featureToggleService)
        return configurator.configure()
    }

    func makeItemDetailsScreen() -> ItemDetailsViewController {
        let configurator = ItemDetailsConfigurator(storage: storage)
        return configurator.configure()
    }

    func makeStoriesModule(indexPath: IndexPath) -> StoriesViewController {
        let configurator = StoriesConfigurator(storage: storage, indexPath: indexPath)
        return configurator.configure()
    }
}

// MARK: - Creating error alerts
private extension MainModuleFactory {
    func makeMainAlertScreen(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.main) {
            completion?()
        }
    }

    func makeItemDetailsAlertScreen(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.productDetails) {
            completion?()
        }
    }

    func makeStoriesAlertScreen(completion: (() -> Void)?) -> UIAlertController {
        return AppAlert.create(.stories) {
            completion?()
        }
    }
}
