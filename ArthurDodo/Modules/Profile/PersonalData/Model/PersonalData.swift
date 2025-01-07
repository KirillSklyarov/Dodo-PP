import Foundation

enum PersonalData: Int, CaseIterable {
    case name
    case phone
    case email
    case dateOfBirth
    case agreeOfSending

    var title: String {
        switch self {
        case .name: return "Имя"
        case .phone: return "Телефон"
        case .email: return "Почта"
        case .dateOfBirth: return "День рождения"
        case .agreeOfSending: return "Разрешить уведомления"
        }
    }
}
