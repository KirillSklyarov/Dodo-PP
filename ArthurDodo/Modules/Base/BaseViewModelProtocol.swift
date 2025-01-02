import Foundation

protocol BaseViewModelProtocol: AnyObject {
    associatedtype ActionType
    func initialize()
    func sendAction(_ action: ActionType)
}
