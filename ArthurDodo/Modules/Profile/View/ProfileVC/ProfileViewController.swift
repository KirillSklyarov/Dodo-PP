import UIKit
import Combine

protocol ProfileViewProtocol: AnyObject {
    func getViewModel() -> ProfileViewModelProtocol
    func updatePersonalData(_ personalData: User?)
    func updatePromo(_ promo: [Promo]?)
}

final class ProfileViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = ProfileHeaderView()
    private lazy var personalDataCollectionView = CoinsOrdersCollectionView()
    private lazy var promoStackView = PromoStackView()
    private lazy var missionStackView = MissionStackView()
    private lazy var contentStackView = AppStackView([personalDataCollectionView, promoStackView, missionStackView], axis: .vertical, spacing: 10)
    private lazy var scrollView = setupScrollView()

    // MARK: - Other Properties
    private let viewModel: ProfileViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Init
    init(viewModel: ProfileViewModelProtocol) {
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
private extension ProfileViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(headerView, scrollView)
        setupLayout()
    }

    // Настраиваем констреинты
    func setupLayout() {
        setupHeaderViewLayout()
        setupScrollViewLayout()
        setupContentStackViewLayout()
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
    // Обновляем личные данные и устанавливаем состояние экрана
    func updatePersonalData(_ personalData: User?) {
        guard let personalData else { return }
        personalDataCollectionView.getPersonalData(personalData)
        setState(view: .personalData, state: .success)
    }

    // Обновляем раздел акции и устанавливаем состояние экрана
    func updatePromo(_ promo: [Promo]?) {
        guard let promo else { return }
        promoStackView.updateUI(promo)
        setState(view: .promo, state: .success)
        setState(view: .mission, state: .success)
    }

    // Отдаем viewModel
    func getViewModel() -> ProfileViewModelProtocol {
        viewModel
    }
}

// MARK: - DataBinding
extension ProfileViewController {
    func dataBinding() {
        viewModel.userDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userData in
                guard let self else { print("ViewModel is nil"); return }
                updatePersonalData(userData)
            }
            .store(in: &cancellables)

        viewModel.promoPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] promo in
                guard let self else { print("ViewModel is nil"); return }
                updatePromo(promo)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Supporting methods
private extension ProfileViewController {
    func setState(view: ProfileView, state: ScreenState) {
        switch view {
        case .personalData: personalDataCollectionView.setState(state)
        case .promo: promoStackView.setState(state)
        case .mission: missionStackView.setState(state)
        }
    }
}
