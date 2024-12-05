import UIKit
import SafariServices

// Экран с личными данными юзера (имя, почта, телефон и проч.)
final class PersonalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .personal) // Заголовок с кнопкой
    private lazy var personalTableView = PersonalTableView()
    private lazy var contentStackView = AppStackView([headerView, personalTableView], axis: .vertical, spacing: 10)

    // MARK: - Other Properties
    private let storage: DataStorage
    private var personalData: User?

    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    init(storage: DataStorage) {
        self.storage = storage
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
        fetchData()
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
            onDismissButtonTapped?()
        }
    }

    func setupPersonalTableViewAction() {
        personalTableView.onShowURL = { [weak self] in
            self?.showURL()
        }
    }
}

// MARK: - Fetch Data
private extension PersonalViewController {
    // Забираем данные с сервера и передаем их для отображения
    func fetchData() {
        self.personalData = storage.getUserData()
        passUserDataToTableView()
    }

    // Передаем данные на tableView для отображения
    func passUserDataToTableView() {
        if let personalData {
            personalTableView.getUserData(personalData)
        }
    }
}

// MARK: - Supporting methods
private extension PersonalViewController {
    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
