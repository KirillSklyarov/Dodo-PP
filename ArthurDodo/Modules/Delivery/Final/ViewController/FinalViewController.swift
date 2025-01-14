import UIKit

protocol FinalViewControllerInput: BaseViewControllerInput where inputData == Int {
    func updateUI(_ seconds: Int)
}

final class FinalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .standard)
    private lazy var contentStack = FinalVCContentStackView()

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Properties
    let output: any FinalViewControllerOutput

    // MARK: - Init
    init(output: any FinalViewControllerOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - FinalViewControllerInput
extension FinalViewController: FinalViewControllerInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        isShowContent(false)
    }

    func configure(with data: Int) {
        activityIndicator.stopAnimating()
        updateUI(data)
        isShowContent(true)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }

    func updateUI(_ seconds: Int) {
        contentStack.updateTitle(seconds)
    }
}

// MARK: - Setup UI
private extension FinalViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack, activityIndicator)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
        setupActivityIndicatorLayout()
    }

    func setupContentStackLayout() {
        contentStack.setLocalConstraints(left: 20, right: 20)
        contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension FinalViewController {
    func setupActions() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.dismissButtonTapped)
        }
    }
}

// MARK: - Supporting methods
private extension FinalViewController {
    func isShowContent(_ show: Bool) {
        contentStack.alpha = show ? 1 : 0
    }
}

//// MARK: - Data binding
//private extension FinalViewController {
//    func dataBinding() {
//        viewModel.timerPublisher
//            .receive(on: RunLoop.main)
//            .sink { [weak self] seconds in
//                guard let self else { return }
//                updateUI(seconds)
//            }
//            .store(in: &cancellables)
//    }
//}
