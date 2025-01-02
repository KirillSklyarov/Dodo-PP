import UIKit

protocol MainScreenFactoryProtocol: AnyObject {
    func makeMainScreen() -> MainViewController
    func makeProductDetailsScreen() -> ProductDetailsViewController
    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC
    func makeAlertScreen(_ type: AlertType) -> UIAlertController
}

// Фабрика экранов модуля главного экрана
final class MainScreenFactory {

    // MARK: - Properties
    private let storage: MainStorage
    private let featureToggleService: FeatureToggleService

    // MARK: - Init
    init(storage: MainStorage, featureToggleService: FeatureToggleService) {
        self.storage = storage
        self.featureToggleService = featureToggleService
    }
}

// MARK: - Methods
extension MainScreenFactory: MainScreenFactoryProtocol {
    func makeMainScreen() -> MainViewController {
        let viewModel = MainViewModel(storage: storage, featureTogglesService: featureToggleService)
        let view = MainViewController(viewModel: viewModel)
        return view
    }

    func makeProductDetailsScreen() -> ProductDetailsViewController {
        let viewModel = ProductDetailsViewModel(storage: storage)
        let view = ProductDetailsViewController(viewModel: viewModel)
        return view
    }

    func makeStoriesScreen(indexPath: IndexPath) -> StoriesVC {
        let viewModel = StoriesViewModel(storage: storage, indexPath: indexPath)
        let view = StoriesVC(viewModel: viewModel)
        return view
    }

    func makeAlertScreen(_ type: AlertType) -> UIAlertController {
        return AppAlert.create(type)
    }
}
