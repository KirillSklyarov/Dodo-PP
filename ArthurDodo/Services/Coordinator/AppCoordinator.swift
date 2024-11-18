import UIKit

protocol Coordinator: AnyObject {
//    var navigationController: UINavigationController { get }
//    func start()
}

// Этот класс отвечает за создание экранов и навигацию внутри приложения. Класс использует помощников по блокам: главный экран, профиль, корзина, адреса.
final class AppCoordinator: Coordinator {

    // MARK: - Properties
    private let storage: DataStorage
    private let router: Router
    private let screenFactory: ScreenFactory
    private var mainCoordinator: MainCoordinator?
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    init(storage: DataStorage, router: Router, screenFactory: ScreenFactory) {
        self.storage = storage
        self.router = router
        self.screenFactory = screenFactory
    }

    func start() {
        let mainCoordinator = MainCoordinator(storage: storage, router: router, screenFactory: screenFactory, mainCoordinator: self)
        self.mainCoordinator = mainCoordinator
        addChild(mainCoordinator)
        mainCoordinator.start()
    }

    func addChild(_ child: Coordinator) {
        childCoordinators.append(child)
    }
}

final class MainCoordinator: Coordinator {
    // MARK: - Properties
    private let storage: DataStorage
    private let router: Router
    private let screenFactory: ScreenFactory
    private var mainVC: MainViewController?
    private var mainCoordinator: Coordinator

    // MARK: - Init
    init(storage: DataStorage, router: Router, screenFactory: ScreenFactory, mainCoordinator: Coordinator) {
        self.storage = storage
        self.router = router
        self.screenFactory = screenFactory
        self.mainCoordinator = mainCoordinator
    }

    func start() {
        let mainVC = screenFactory.makeMainScreen()
        self.mainVC = mainVC
        router.present(vc: mainVC, animated: false)

        mainVC.onProfileButtonTapped = { [weak self] in
            self?.showProfile()
        }

        mainVC.onAddressButtonTapped = { [weak self] in
            self?.showAddress()
        }

        mainVC.onStoryTapped = { [weak self] indexPath in
            self?.showStories(indexPath)
        }

        mainVC.onProductDetailsTapped = { [weak self] in
            self?.showProductDetails()
        }

        mainVC.onCartButtonTapped = { [weak self] in
            guard let self else { return }
            let cartCoordinator = CartCoordinator(storage: storage, router: router, screenFactory: screenFactory, mainVC: mainVC)
            guard let mainCoordinator = mainCoordinator as? AppCoordinator else { print("Error: MainCoordinator is not AppCoordinator"); return }
            mainCoordinator.addChild(cartCoordinator)
            cartCoordinator.start(mainVC)
        }
    }

    // Показ экрана деталей товара и связанные с ним операции
    private func showProductDetails() {
        let vc = screenFactory.makeProductDetailsScreen()
        router.present(vc: vc, parentVC: mainVC, animated: true)

        vc.onCartButtonTapped = { [weak self] in
            self?.mainVC?.updateUI()
        }

        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }

        vc.onShowPopupVC = { [weak self] popUpView in
            self?.router.present(vc: popUpView, parentVC: vc, modalPresentation: .popover, animated: true)
        }
    }

    func showProfile() {
        let profileCoordinator = ProfileCoordinator(storage: storage, router: router, screenFactory: screenFactory)
        guard let mainVC else { print(#function); return }
        guard let mainCoordinator = mainCoordinator as? AppCoordinator else { print(#function); return }
        mainCoordinator.addChild(profileCoordinator)
        profileCoordinator.start(mainVC)
    }

    func showAddress() {
        let addressCoordinator = AddressCoordinator(storage: storage, router: router, screenFactory: screenFactory)
        guard let mainVC else { return }
        guard let mainCoordinator = mainCoordinator as? AppCoordinator else { return }
        mainCoordinator.addChild(addressCoordinator)
        addressCoordinator.start(mainVC)
    }

    func showStories(_ indexPath: IndexPath) {
        let vc = screenFactory.makeStoriesScreen(indexPath: indexPath)
        router.present(vc: vc, parentVC: mainVC)
        vc.onStoriesVCDismissed = { [weak self] in
            self?.mainVC?.updateUI()
        }
        
        vc.onDismissButtonTapped = { [weak self] in
            self?.router.dismissVC(vc: vc)
        }
    }
}
