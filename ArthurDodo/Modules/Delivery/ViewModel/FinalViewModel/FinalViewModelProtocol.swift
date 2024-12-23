import Foundation
import Combine

protocol FinalViewModelProtocol {
    func initialize()
    func dismissVC()

    var timerPublisher: Published<Int>.Publisher { get }
    var onFinalVCDismissed: (() -> Void)? { get set }
}
