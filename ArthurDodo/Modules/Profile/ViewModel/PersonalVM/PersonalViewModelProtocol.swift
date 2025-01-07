import Foundation

protocol PersonalViewModelProtocol: BaseViewModelProtocol where ActionType == PersonalDataAction {

    func setInitialState()

    var onScreenStateChanged: ((PersonalDataScreenState) -> Void)? { get set }
    var onShowURL: ((URL) -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
}
