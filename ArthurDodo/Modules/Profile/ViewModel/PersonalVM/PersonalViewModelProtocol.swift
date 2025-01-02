import Foundation
import Combine

protocol PersonalViewModelProtocol: AnyObject {
    func initialize()
    func sendAction(_ action: PersonalDataAction)

    var personalDataPublisher: Published<User?>.Publisher { get }
    var urlPublisher: Published<URL?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
}
