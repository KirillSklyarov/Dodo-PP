import Combine

protocol AddNewAddressVMProtocol: AnyObject {
    func initialize()
    func sendAction(_ action: AddNewAddressAction)

    var mainAddressPublisher: Published<Address?>.Publisher { get }

    var onDismissButtonTapped: (() -> Void)? { get set }
    var onSaveNewAddressButtonTapped: (() -> Void)? { get set }
}
