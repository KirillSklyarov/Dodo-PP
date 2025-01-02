import Foundation
import Combine

protocol PersonalViewModelProtocol: BaseViewModelProtocol where ActionType == PersonalDataAction {

    var personalDataPublisher: Published<User?>.Publisher { get }
    var urlPublisher: Published<URL?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
}
