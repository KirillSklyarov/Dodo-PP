import Foundation

protocol BaseViewControllerOutput: AnyObject {
    associatedtype ActionType
    func viewLoaded()
    func sendAction(_ action: ActionType)
    func updateViewWithData()
}


protocol BaseViewControllerOutputOLD: AnyObject {
    associatedtype ActionType
    func initialize()
    func sendAction(_ action: ActionType)
}
