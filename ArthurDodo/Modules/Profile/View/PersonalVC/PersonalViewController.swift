import UIKit
import SafariServices
import Combine

protocol PersonalViewProtocol: AnyObject {
    func updateUserData(_ personalData: User?)
    func showURL(url: URL?)
    func getViewModel() -> PersonalViewModelProtocol
}

// Экран с личными данными юзера (имя, почта, телефон и проч.)
final class PersonalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .personal) // Заголовок с кнопкой
    private lazy var personalTableView = PersonalTableView()
    private lazy var contentStackView = AppStackView([headerView, personalTableView], axis: .vertical, spacing: 10)

    // MARK: - Properties
    let viewModel: PersonalViewModelProtocol

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: PersonalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        dataBinding()
        viewModel.initialize()
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
            viewModel.onDismissButtonTapped?()
        }
    }

    func setupPersonalTableViewAction() {
        personalTableView.onShowURL = { [weak self] in
            self?.viewModel.showURL()
        }
    }
}

// MARK: - PersonalViewProtocol
extension PersonalViewController: PersonalViewProtocol {
    // Обновляем UI c персональными данными
    func updateUserData(_ personalData: User?) {
        guard let personalData else { return }
        personalTableView.getUserData(personalData)
    }

    // Показываем ссылку
    func showURL(url: URL?) {
        guard let url else { return }
        guard UIApplication.shared.canOpenURL(url) else { print("Can't open URL"); return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    // Отдаем viewModel
    func getViewModel() -> PersonalViewModelProtocol {
        viewModel
    }
}

// MARK: - Data Binding
private extension PersonalViewController {
    func dataBinding() {
        viewModel.personalDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] personalData in
                self?.updateUserData(personalData)
            }
            .store(in: &cancellables)

        viewModel.urlPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.showURL(url: url)
            }
            .store(in: &cancellables)
    }
}
