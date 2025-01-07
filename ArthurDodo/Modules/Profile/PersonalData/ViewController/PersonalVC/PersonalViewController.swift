import UIKit

// Экран с личными данными юзера (имя, почта, телефон и проч.)
final class PersonalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .personal) // Заголовок с кнопкой
    private lazy var personalTableView = PersonalTableView()
    private lazy var contentStackView = AppStackView([headerView, personalTableView], axis: .vertical, spacing: 10)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Properties
    let viewModel: any PersonalViewModelProtocol

    // MARK: - Init
    init(viewModel: any PersonalViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBinding()

        viewModel.setInitialState()
        viewModel.initialize()
    }
}

// MARK: - Setup UI
private extension PersonalViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStackView, activityIndicator)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackViewLayout()
        setupActivityIndicatorLayout()
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints(isSafeArea: true, allInsets: 10)
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
            viewModel.sendAction(.dismissButtonTapped)
        }
    }

    func setupPersonalTableViewAction() {
        personalTableView.onShowURL = { [weak self] in
            self?.viewModel.sendAction(.showURLTapped)
        }
    }
}

// MARK: - Data Binding
private extension PersonalViewController {
    func dataBinding() {
        viewModel.onScreenStateChanged = { [weak self] screenState in
            self?.setupScreenState(screenState)
        }
    }
}

// MARK: - State management
private extension PersonalViewController {
    // Вызываем настройку, соответствующую состоянию экрана
    func setupScreenState(_ screenState: PersonalDataScreenState) {
        switch screenState {
        case .initial: setupInitialState()
        case .loading: setupLoadingState()
        case .success(let personalData): setupSuccessState(personalData)
        case .error: setupErrorState()
        }
    }

    // Настраиваем первоначальный экран
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    // Настраиваем экран загрузки (убираем контент и показываем индикатор)
    func setupLoadingState() {
        contentStackView.alpha = 0
        activityIndicator.startAnimating()
    }

    // Настраиваем экран полученных данных (показываем контент и обновляем его с учетом полученных данных)
    func setupSuccessState(_ personalData: User) {
        contentStackView.alpha = 1
        updateUI(with: personalData)
        activityIndicator.stopAnimating()
    }

    // Обновляем UI c персональными данными
    func updateUI(with personalData: User) {
        personalTableView.getUserData(personalData)
    }

    // Настраиваем экран с ошибкой
    func setupErrorState() {
        activityIndicator.stopAnimating()
    }
}
