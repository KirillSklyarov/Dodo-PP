import Foundation

protocol BaseViewControllerInput: AnyObject {
    associatedtype inputData

    func setupInitialState()
    func showLoading()
    func showError()

    func configure(with data: inputData)
}
