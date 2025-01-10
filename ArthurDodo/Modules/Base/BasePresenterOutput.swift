import Foundation

protocol BasePresenterOutput: AnyObject {
    associatedtype ActionType
    func initialize()
    func sendAction(_ action: ActionType)
}
