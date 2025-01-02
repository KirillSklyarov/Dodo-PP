import Foundation
import Combine

protocol FinalViewModelProtocol {
    func initialize()
    func sendAction(_ action: FinalViewModelAction)

    var timerPublisher: Published<Int>.Publisher { get }
    var onFinalVCDismissed: (() -> Void)? { get set }
}
