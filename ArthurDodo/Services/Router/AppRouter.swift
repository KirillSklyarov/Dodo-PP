import UIKit

enum Screens {
    case main
    case profile
    case productDetails
    case stories
    case address
    case cart
    case supportAlert
    case editAddress
    case applySpecialOffer
    case personalData
    case cpfcPopup
    case delivery
    case paymentChooseAddress
    case addNewAddress
    case choosePaymentMethod
    case final
}

// Этот класс отвечает за создание экранов и навигацию внутри приложения. Класс использует помощников по блокам: главный экран, профиль, корзина, адреса.
final class AppRouter {

    // MARK: - Properties
    private let navigationController: UINavigationController
    private let storage: DataStorage

    // MARK: - Supporting routers
    private var mainRouter: MainRouter?
    private var profileRouter: ProfileRouter?
    private var cartRouter: CartRouter?
    private var addressRouter: AddressRouter?

    // MARK: - Init
    init(navigationController: UINavigationController, storage: DataStorage) {
        self.navigationController = navigationController
        self.storage = storage

        setupRouters()
    }

    // Показываем новый экран, там где нужно настраиваем коллбэки
    func navigate(to screen: Screens,
                  popUpView: CpfcPopupView? = nil,
                  callback: ( (UIViewController) -> Void)? = nil) {
        
        switch screen {
        case .main: mainRouter?.goToMainVC(router: self)
        case .stories: mainRouter?.goToStories(callback: callback)
        case .productDetails: mainRouter?.goToProductDetails(router: self, callback: callback)
        case .cpfcPopup: mainRouter?.showPopUpView(popUpView)
            
            // Блок адреса
        case .address: addressRouter?.goToAddressVC(router: self)
        case .editAddress: addressRouter?.goToEditAddressVC(callback: callback)
        case .addNewAddress: addressRouter?.goToAddNewAddress(callback: callback)

            // Блок профиля
        case .profile: profileRouter?.goToProfile(router: self)
        case .supportAlert: profileRouter?.goToChatAlert()
        case .personalData: profileRouter?.goToPersonalData()
            
            // Блок Корзины
        case .cart: cartRouter?.goToCart(router: self, callback: callback)
        case .delivery: cartRouter?.goToDelivery(router: self)
        case .applySpecialOffer: cartRouter?.goToApplySpecialOffer(callback: callback)
        case .choosePaymentMethod: cartRouter?.goToChoosePaymentMethodVC(callback: callback)
        case .paymentChooseAddress: cartRouter?.goToChooseAddress(router: self, callback: callback)
        case .final: cartRouter?.goToFinalVC(router: self)
        }
    }

    // Закрываем все окна до Main
    func dismissAllVC() {
        navigationController.dismiss(animated: true)
    }
}

// MARK: - Setup supporting routers
private extension AppRouter {
    private func setupRouters() {
        mainRouter = MainRouter(storage: storage, navigationController: navigationController)
        profileRouter = ProfileRouter(storage: storage, navigationController: navigationController)
        cartRouter = CartRouter(storage: storage, navigationController: navigationController)
        addressRouter = AddressRouter(storage: storage, navigationController: navigationController)
    }
}
