import UIKit

protocol FinalViewProtocol: AnyObject {
    func updateUI(_ seconds: Int)
}

final class FinalVC: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = AppDismissButtonView(type: .standard)
    private lazy var contentStack = FinalVCContentStackView()

    // MARK: - Presenter
    let presenter: FinalPresenterProtocol

    // MARK: - Init
    init(presenter: FinalPresenterProtocol) {
        self.presenter = presenter
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
        presenter.viewDidLoad()
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
            presenter.dismissVC()
        }
    }
}

// MARK: - FinalViewProtocol
extension FinalVC: FinalViewProtocol {
    func updateUI(_ seconds: Int) {
        contentStack.updateTitle(seconds)
    }
}
