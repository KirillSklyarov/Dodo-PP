import Foundation

protocol BaseViewControllerOutput: AnyObject {
    associatedtype ActionType
    associatedtype CoordinatorEvent
    associatedtype ViewInputProtocol

    var view: ViewInputProtocol? { get set }

    func viewLoaded()
    func sendAction(_ action: ActionType)
    func loadData()
    func checkDataAndUpdateView()

    var coordinatorEventHandler: ((CoordinatorEvent) -> Void)? { get set }
}
