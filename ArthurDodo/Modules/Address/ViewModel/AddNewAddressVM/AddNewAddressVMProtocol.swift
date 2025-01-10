import Combine

protocol AddNewAddressVMProtocol: BaseViewControllerOutputOLD where ActionType == AddNewAddressAction {

    var mainAddressPublisher: Published<Address?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onSaveNewAddressButtonTapped: (() -> Void)? { get set }
}
