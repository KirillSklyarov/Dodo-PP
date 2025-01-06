import UIKit

protocol ProfileViewProtocol: AnyObject {
    func getViewModel() -> any ProfileViewModelProtocol
}

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var personalDataCollectionView = CoinsOrdersCollectionView()
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView = AppStackView([personalDataCollectionView, promoStackView, missionStackView], axis: .vertical, spacing: 10)
    private lazy var scrollView = setupScrollView()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = AppColors.buttonOrange
        return activityIndicator
    }()

    // MARK: - Other Properties
    private let viewModel: any ProfileViewModelProtocol

    // MARK: - Init
    init(viewModel: any ProfileViewModelProtocol) {
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
        viewModel.initialize()
    }
}

// MARK: - Setup UI
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, scrollView, activityIndicator)
        setupLayout()
    }

    // Настраиваем констреинты
    func setupLayout() {
        setupHeaderViewLayout()
        setupScrollViewLayout()
        setupContentStackViewLayout()
        setupActivityIndicatorLayout()
    }

    func setupHeaderViewLayout() {
        headerView.setLocalConstraints(isSafeArea: true, top: 10, left: 10, right: 10)
    }

    func setupScrollViewLayout() {
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        scrollView.setLocalConstraints(isSafeArea: true, bottom: 10, left: 10, right: 10)
    }

    func setupContentStackViewLayout() {
        contentStackView.setConstraints()
        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    // Настраиваем скролл вью
    func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubviews(contentStackView)
        return scrollView
    }

    // Настраиваем activityIndicator
    func setupActivityIndicatorLayout() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Actions
private extension ProfileViewController {
    func setupActions() {
        setupHeaderViewActions()
        setupPersonalDataActions()
        setupPromoActions()
    }

    // Настройка действий header view (где 3 кнопки)
    func setupHeaderViewActions() {
        headerView.onDismissButtonTapped = { [weak self] in
            self?.viewModel.sendAction(.dismissButtonTapped)
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.viewModel.sendAction(.chatAlertButtonTapped)
        }

        headerView.onProfileButtonTapped = { [weak self] in
            self?.viewModel.sendAction(.personalDataButtonTapped)
        }
    }

    func setupPersonalDataActions() {
        personalDataCollectionView.onAddressCellTapped = { [weak self] in
            guard let self else { return }
            viewModel.sendAction(.addressCellTapped)
        }
    }

    // Настройка действий секции Акции
    func setupPromoActions() {
        promoStackView.onPromoSelected = { [weak self] promo in
            guard let self else { return }
            viewModel.sendAction(.promoTapped(promo))
        }
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    // Отдаем viewModel
    func getViewModel() -> any ProfileViewModelProtocol {
        viewModel
    }
}

// MARK: - DataBinding
private extension ProfileViewController {
    func dataBinding() {
        viewModel.onStateChanged = { [weak self] state in
            self?.showScreenState(state)
        }
    }
}

// MARK: - Supporting methods
private extension ProfileViewController {
    // Управление состоянием экрана
    func showScreenState(_ state: ProfileScreenState) {
        switch state {
        case .initial:
            setupUI()
            setupActions()
            print(state)
        case .loading:
            setState(view: .personalData, state: .loading)
            setState(view: .mission, state: .loading)
            setState(view: .promo, state: .loading)
        case .success(let user, let promo):
            updatePersonalData(user)
            updatePromo(promo)
        case .error: print(state)
        }
    }

    // Обновляем личные данные и устанавливаем состояние экрана
    func updatePersonalData(_ personalData: User) {
        personalDataCollectionView.getPersonalData(personalData)
        setState(view: .personalData, state: .success)
    }

    // Обновляем раздел акции и устанавливаем состояние экрана
    func updatePromo(_ promo: [Promo]) {
        promoStackView.updateUI(promo)
        setState(view: .promo, state: .success)
        setState(view: .mission, state: .success)
    }


    func setState(view: ProfileView, state: ScreenState) {
        switch view {
        case .personalData: personalDataCollectionView.setState(state)
        case .promo: promoStackView.setState(state)
        case .mission: missionStackView.setState(state)
        }
    }
}
