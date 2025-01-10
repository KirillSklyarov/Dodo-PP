import UIKit

protocol ProfileViewInput: BaseViewControllerInput {
    func configure(with profile: User, _ promo: [Promo])
}

final class ProfileViewController: UIViewController, ModuleTransitionable {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var personalDataCollectionView = CoinsOrdersCollectionView()
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView = AppStackView([personalDataCollectionView, promoStackView, missionStackView], axis: .vertical, spacing: 10)
    private lazy var scrollView = setupScrollView()

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Other Properties
    let output: ProfileViewOutput

    init(output: ProfileViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded() // Первый метод, который говорит, что view загружена
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
            self?.output.sendAction(.dismissButtonTapped)
        }

        headerView.onChatButtonTapped = { [weak self] in
            self?.output.sendAction(.chatAlertButtonTapped)
        }

        headerView.onProfileButtonTapped = { [weak self] in
            self?.output.sendAction(.personalDataButtonTapped)
        }
    }

    func setupPersonalDataActions() {
        personalDataCollectionView.onAddressCellTapped = { [weak self] in
            guard let self else { return }
            output.sendAction(.addressCellTapped)
        }
    }

    // Настройка действий секции Акции
    func setupPromoActions() {
        promoStackView.onPromoSelected = { [weak self] promo in
            guard let self else { return }
            output.sendAction(.promoTapped(promo))
        }
    }
}

// MARK: - ProfileViewInput
extension ProfileViewController: ProfileViewInput {
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }

    func configure(with profile: User, _ promo: [Promo]) {
        isShowContent(true)
        activityIndicator.stopAnimating()
        updatePersonalData(profile)
        updatePromo(promo)
    }

    func showError() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Supporting methods
private extension ProfileViewController {
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

    func isShowContent(_ bool: Bool) {
        let alpha: CGFloat = bool ? 1 : 0
        [headerView, contentStackView].forEach { $0.alpha = alpha }
    }
}




//
//final class ProfileViewController: UIViewController {
//
//    // MARK: - UI Properties
//    private lazy var headerView = ProfileHeaderView()
//    private lazy var personalDataCollectionView = CoinsOrdersCollectionView()
//    private lazy var promoStackView = PromoStackView()
//    private lazy var missionStackView = MissionStackView()
//    private lazy var contentStackView = AppStackView([personalDataCollectionView, promoStackView, missionStackView], axis: .vertical, spacing: 10)
//    private lazy var scrollView = setupScrollView()
//
//    // MARK: - Other Properties
//    let viewModel: any ProfileViewModelProtocol
//
//    // MARK: - Init
//    init(viewModel: any ProfileViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        dataBinding()
//
//        viewModel.setInitialState()
//        viewModel.initialize()
//    }
//}
//
//// MARK: - Setup UI
//private extension ProfileViewController {
//    func setupUI() {
//        view.backgroundColor = AppColors.backgroundBlack
//        view.addSubviews(headerView, scrollView)
//        setupLayout()
//    }
//
//    // Настраиваем констреинты
//    func setupLayout() {
//        setupHeaderViewLayout()
//        setupScrollViewLayout()
//        setupContentStackViewLayout()
//    }
//
//    func setupHeaderViewLayout() {
//        headerView.setLocalConstraints(isSafeArea: true, top: 10, left: 10, right: 10)
//    }
//
//    func setupScrollViewLayout() {
//        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
//        scrollView.setLocalConstraints(isSafeArea: true, bottom: 10, left: 10, right: 10)
//    }
//
//    func setupContentStackViewLayout() {
//        contentStackView.setConstraints()
//        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//    }
//
//    // Настраиваем скролл вью
//    func setupScrollView() -> UIScrollView {
//        let scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.addSubviews(contentStackView)
//        return scrollView
//    }
//}
//
//// MARK: - Setup Actions
//private extension ProfileViewController {
//    func setupActions() {
//        setupHeaderViewActions()
//        setupPersonalDataActions()
//        setupPromoActions()
//    }
//
//    // Настройка действий header view (где 3 кнопки)
//    func setupHeaderViewActions() {
//        headerView.onDismissButtonTapped = { [weak self] in
//            self?.viewModel.sendAction(.dismissButtonTapped)
//        }
//
//        headerView.onChatButtonTapped = { [weak self] in
//            self?.viewModel.sendAction(.chatAlertButtonTapped)
//        }
//
//        headerView.onProfileButtonTapped = { [weak self] in
//            self?.viewModel.sendAction(.personalDataButtonTapped)
//        }
//    }
//
//    func setupPersonalDataActions() {
//        personalDataCollectionView.onAddressCellTapped = { [weak self] in
//            guard let self else { return }
//            viewModel.sendAction(.addressCellTapped)
//        }
//    }
//
//    // Настройка действий секции Акции
//    func setupPromoActions() {
//        promoStackView.onPromoSelected = { [weak self] promo in
//            guard let self else { return }
//            viewModel.sendAction(.promoTapped(promo))
//        }
//    }
//}
//
//// MARK: - DataBinding
//private extension ProfileViewController {
//    func dataBinding() {
//        viewModel.onStateChanged = { [weak self] state in
//            self?.showScreenState(state)
//        }
//    }
//}
//
//// MARK: - Supporting methods
//private extension ProfileViewController {
//    // Управление состоянием экрана
//    func showScreenState(_ state: ProfileScreenState) {
//        switch state {
//        case .initial:
//            setupUI()
//            setupActions()
//            print(state)
//        case .loading:
//            setState(view: .personalData, state: .loading)
//            setState(view: .mission, state: .loading)
//            setState(view: .promo, state: .loading)
//        case .success((let user, let promo)):
//            updatePersonalData(user)
//            updatePromo(promo)
//        case .error: print(state)
//        }
//    }
//
//    // Обновляем личные данные и устанавливаем состояние экрана
//    func updatePersonalData(_ personalData: User) {
//        personalDataCollectionView.getPersonalData(personalData)
//        setState(view: .personalData, state: .success)
//    }
//
//    // Обновляем раздел акции и устанавливаем состояние экрана
//    func updatePromo(_ promo: [Promo]) {
//        promoStackView.updateUI(promo)
//        setState(view: .promo, state: .success)
//        setState(view: .mission, state: .success)
//    }
//
//
//    func setState(view: ProfileView, state: ScreenState) {
//        switch view {
//        case .personalData: personalDataCollectionView.setState(state)
//        case .promo: promoStackView.setState(state)
//        case .mission: missionStackView.setState(state)
//        }
//    }
//}
