import Foundation
import Combine

protocol PersonalViewModelProtocol: AnyObject {
    func initialize()
    func showURL()

    var personalDataPublisher: Published<User?>.Publisher { get }
    var urlPublisher: Published<URL?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
}
