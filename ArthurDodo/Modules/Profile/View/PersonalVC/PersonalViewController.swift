import UIKit
import SafariServices

protocol PersonalViewProtocol: AnyObject {
    func updateUserData(_ personalData: User)
    func showURL(url: URL)
}

// Экран с личными данными юзера (имя, почта, телефон и проч.)
final class PersonalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .personal) // Заголовок с кнопкой
    private lazy var personalTableView = PersonalTableView()
    private lazy var contentStackView = AppStackView([headerView, personalTableView], axis: .vertical, spacing: 10)

    // MARK: - Properties
    let presenter: PersonalPresenter

    // MARK: - Init
    init(presenter: PersonalPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter.viewDidLoad()
    }
}

// MARK: - Setup UI
private extension PersonalViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true, allInsets: 10)
    }
}

// MARK: - Setup Actions
private extension PersonalViewController {
    func setupActions() {
        setupHeaderViewAction()
        setupPersonalTableViewAction()
    }

    func setupHeaderViewAction() {
        headerView.onDismissButtonTapped = { [weak self] in
            guard let self else { return }
            presenter.onDismissButtonTapped?()
        }
    }

    func setupPersonalTableViewAction() {
        personalTableView.onShowURL = { [weak self] in
            self?.presenter.showURL()
        }
    }
}

// MARK: - PersonalViewProtocol
extension PersonalViewController: PersonalViewProtocol {
    func updateUserData(_ personalData: User) {
        personalTableView.getUserData(personalData)
    }

    func showURL(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
