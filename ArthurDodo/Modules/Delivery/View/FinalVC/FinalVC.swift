import UIKit
import Combine

final class FinalVC: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .standard)
    private lazy var contentStack = FinalVCContentStackView()

    // MARK: - ViewModel
    private let viewModel: any FinalViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: any FinalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        dataBinding()

        viewModel.initialize()
    }
}

// MARK: - Setup UI
private extension FinalVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        contentStack.setLocalConstraints(left: 20, right: 20)
        contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension FinalVC {
    func setupActions() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            viewModel.sendAction(.dismissButtonTapped)
        }
    }
}

// MARK: - FinalViewProtocol
extension FinalVC: FinalViewProtocol {
    func getViewModel() -> any FinalViewModelProtocol {
        viewModel
    }

    func updateUI(_ seconds: Int) {
        contentStack.updateTitle(seconds)
    }
}

// MARK: - Data binding
private extension FinalVC {
    func dataBinding() {
        viewModel.timerPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] seconds in
                guard let self else { return }
                updateUI(seconds)
            }
            .store(in: &cancellables)
    }
}
