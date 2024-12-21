import Combine
import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var userDataPublisher: Published<User?>.Publisher { get }
    var promoPublisher: Published<[Promo]?>.Publisher { get }

    var onShowChatAlert: (() -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowPersonalData: (() -> Void)?  { get set }
    var onShowPromoVC: ((Promo) -> Void)?  { get set }

    func initialize()
}
