import Foundation

protocol BaseViewControllerInput: AnyObject {
    associatedtype inputData
//    associatedtype ViewControllerOutputProtocol

//    var output: ViewControllerOutputProtocol { get set }

    func setupInitialState()
    func showLoading()
    func configure(with data: inputData)
    func showError()
}
