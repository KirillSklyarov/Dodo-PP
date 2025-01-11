import UIKit

protocol BaseModuleFactory: AnyObject {
    associatedtype Module
    associatedtype ErrorType

    func makeModule(for module: Module) -> UIViewController
    func makeErrorAlert(for errorAlert: ErrorType, completion: (() -> Void)?) -> UIAlertController
}
