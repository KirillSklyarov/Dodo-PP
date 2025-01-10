import Foundation

protocol BaseViewControllerInput: AnyObject {
    func setupInitialState()
    func showLoading()
    func showError()
}
