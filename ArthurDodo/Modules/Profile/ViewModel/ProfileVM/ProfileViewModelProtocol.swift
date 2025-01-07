import Combine

protocol ProfileViewModelProtocol: BaseViewModelProtocol where ActionType == ProfileAction {

    func setInitialState()

    var onShowChatAlert: (() -> Void)? { get set }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onShowPersonalData: (() -> Void)?  { get set }
    var onShowPromoVC: (() -> Void)?  { get set }
    var onAddressCellTapped: (() -> Void)? { get set}
    var onStateChanged: ((ProfileScreenState) -> Void)? { get set }
    var onShowErrorAlert: (() -> Void)? { get set }
}
