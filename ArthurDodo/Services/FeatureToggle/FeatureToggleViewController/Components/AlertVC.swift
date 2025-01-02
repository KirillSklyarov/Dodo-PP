import UIKit

enum AlertType {
    case profile
    case cart
    case productDetails
}

final class AppAlert {
    static func create(_ type: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка доступа", message: "", preferredStyle: .alert)

        switch type {
        case .profile:
            alert.message = "Профиль временно недоступен, но очень скоро заработает!"
        case .cart:
            alert.message = "Корзина временно недоступна, но очень скоро заработает!"
        case .productDetails:
            alert.message = "Детали продукта временно недоступны, но очень скоро заработают!"
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
