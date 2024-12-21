import Foundation
import Combine

protocol AddNewAddressVMProtocol: AnyObject {
    func initialize()
    func saveNewAddressButtonTapped(_ newAddress: Address) 

    var mainAddressPublisher: Published<Address?>.Publisher { get }
    var onDismissButtonTapped: (() -> Void)? { get set }
    var onSaveNewAddressButtonTapped: (() -> Void)? { get set }
}
