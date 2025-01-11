import UIKit

enum AlertType {
    case profile
    case cart
    case productDetails
    case chooseAddress
    case personalData
    case editItem
}

final class AppAlert {
    static func create(_ type: AlertType, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка загрузки данных", message: "", preferredStyle: .alert)
        alert.message =
        switch type {
        case .profile: "Ошибка загрузки профиля, попробуйте позже!"
        case .cart: "Корзина временно недоступна, но очень скоро заработает!"
        case .productDetails: "Детали продукта временно недоступны, но очень скоро заработают!"
        case .chooseAddress: "Не удалось загрузить адреса, попробуйте позже!"
        case .personalData: "Не удалось загрузить личные данные, попробуйте позже!"
        case .editItem: "Не удалось загрузить позицию для изменения, попробуйте позже!"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        })
        return alert
    }
}
