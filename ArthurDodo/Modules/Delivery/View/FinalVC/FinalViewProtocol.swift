import Foundation

protocol FinalViewProtocol: AnyObject {
    func getViewModel() -> FinalViewModelProtocol
    func updateUI(_ seconds: Int)
}
