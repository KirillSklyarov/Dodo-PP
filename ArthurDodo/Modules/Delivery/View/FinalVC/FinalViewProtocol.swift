import Foundation

protocol FinalViewProtocol: AnyObject {
    func getViewModel() -> any FinalViewModelProtocol
    func updateUI(_ seconds: Int)
}
