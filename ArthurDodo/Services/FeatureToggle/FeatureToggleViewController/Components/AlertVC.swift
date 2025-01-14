import UIKit

enum AlertType {
    case main
    case stories
    case profile
    case cart
    case productDetails
    case chooseAddress
    case personalData
    case editItem
    case delivery
    case paymentMethod
    case final
    case address
    case addressToEdit
    case addNewAddress
}

final class AppAlert {
    static func create(_ type: AlertType, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка загрузки данных", message: "", preferredStyle: .alert)
        alert.message =
        switch type {
        case .main: "Ошибка загрузки данных, попробуйте позже!"
        case .stories: "Ошибка загрузки историй, попробуйте позже!"
        case .profile: "Ошибка загрузки профиля, попробуйте позже!"
        case .cart: "Корзина временно недоступна, но очень скоро заработает!"
        case .productDetails: "Детали продукта временно недоступны, но очень скоро заработают!"
        case .chooseAddress: "Не удалось загрузить адреса, попробуйте позже!"
        case .personalData: "Не удалось загрузить личные данные, попробуйте позже!"
        case .editItem: "Не удалось загрузить позицию для изменения, попробуйте позже!"
        case .delivery: "Не удалось загрузить модуль доставки, попробуйте позже!"
        case .paymentMethod: "Не удалось загрузить способы оплаты, попробуйте позже!"
        case .final: "Не удалось загрузить финальные данные, попробуйте позже!"
        case .address: "Не удалось загрузить адреса, попробуйте позже!"
        case .addressToEdit: "Не удалось загрузить адреса для изменения, попробуйте позже!"
        case .addNewAddress: "Не удалось загрузить адреса для добавления, попробуйте позже!"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        })
        return alert
    }
}
