import Foundation

protocol BaseViewControllerOutput: AnyObject {
    associatedtype ActionType
    func viewLoaded()
    func sendAction(_ action: ActionType)
    func loadData()
    func checkDataAndUpdateView()
}


protocol BaseViewControllerOutputOLD: AnyObject {
    associatedtype ActionType
    func loadData()
    func sendAction(_ action: ActionType)
}
