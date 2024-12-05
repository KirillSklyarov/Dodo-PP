import UIKit

enum AlertType {
    case profile
}

final class AppAlert {
    static func create(_ type: AlertType) -> UIAlertController {
        let alert: UIAlertController

        switch type {
        case .profile:
            alert = UIAlertController(title: "Ошибка доступа", message: "Профиль временно недоступен, но очень скоро заработает!", preferredStyle: .alert)
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
}
