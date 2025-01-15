import Foundation

protocol BaseViewControllerOutput: AnyObject {
    associatedtype ActionType
    associatedtype CoordinatorEvent

    func viewLoaded()
    func sendAction(_ action: ActionType)
    func loadData()
    func checkDataAndUpdateView()

    var coordinatorEventHandler: ((CoordinatorEvent) -> Void)? { get set }
}
