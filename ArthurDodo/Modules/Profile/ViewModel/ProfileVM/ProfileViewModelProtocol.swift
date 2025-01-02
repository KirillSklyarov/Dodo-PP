import Combine
import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    func initialize()
    func sendAction(_ action: ProfileAction)

    var userDataPublisher: Published<User?>.Publisher { get }
    var promoPublisher: Published<[Promo]?>.Publisher { get }

    var onShowChatAlert: (() -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowPersonalData: (() -> Void)?  { get set }
    var onShowPromoVC: (() -> Void)?  { get set }
    var onAddressCellTapped: (() -> Void)? { get set}
}
