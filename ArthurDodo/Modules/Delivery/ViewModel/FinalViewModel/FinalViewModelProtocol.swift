import Foundation
import Combine

protocol FinalViewModelProtocol: BaseViewModelProtocol where ActionType == FinalViewModelAction {

    var timerPublisher: Published<Int>.Publisher { get }
    var onFinalVCDismissed: (() -> Void)? { get set }
}
