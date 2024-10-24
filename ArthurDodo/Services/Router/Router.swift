//
//  Router.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 24.10.2024.
//

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
}

final class Router {

    // Откуда будет вызывать показ нового экрана
    var baseVC: UIViewController

    // MARK: - Init
    init(baseVC: UIViewController) {
        self.baseVC = baseVC
    }

    // Показываем новый экран, там где нужно настраиваем коллбэки 
    func navigate(to screen: Screens,
                  popUpView: CpfcPopupView? = nil,
                  animated: Bool = true,
                  callback: ( (UIViewController) -> Void)? = nil) {
        var vc: UIViewController

        switch screen {
        case .main: vc = MainViewController()
        case .profile: vc = ProfileViewController()
        case .productDetails:
            vc = ProductDetailsViewController()
            vc.modalPresentationStyle = .fullScreen
            callback?(vc)
        case .stories:
            vc = StoriesVC()
            vc.modalPresentationStyle = .fullScreen
            callback?(vc)
        case .address:
            vc = AddressViewController()
            vc.modalPresentationStyle = .fullScreen
        case .cart:
            let cartVC = CartViewController()
            vc = UINavigationController(rootViewController: cartVC)
        case .supportAlert:
            vc = CustomActionSheet()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
        case .editAddress:
            vc = EditAddressViewController()
            vc.modalPresentationStyle = .fullScreen
            callback?(vc)
        case .applySpecialOffer:
            vc = ApplyOfferViewController()
            guard let configureSheet = vc.sheetPresentationController else { return }
            configureSheet.detents = [.medium()]
            configureSheet.prefersGrabberVisible = true
            callback?(vc)
        case .personalData:
            let personalDataVC = PersonalViewController()
            vc = UINavigationController(rootViewController: personalDataVC)
        case .cpfcPopup:
            guard let popUpView else {
                print("Something went wrong with the popup"); return }
            vc = popUpView
        }

        baseVC.present(vc, animated: animated)
    }
}
