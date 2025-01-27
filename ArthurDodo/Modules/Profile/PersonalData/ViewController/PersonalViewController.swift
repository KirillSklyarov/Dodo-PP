import UIKit
import AppUIComponentsSPM

protocol PersonalViewInput: BaseViewControllerInput where inputData == User {
}

// Экран с личными данными юзера (имя, почта, телефон и проч.)
final class PersonalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var headerView = AppNavigationBarView(type: .personal) // Заголовок с кнопкой
    private lazy var personalTableView = PersonalTableView()
    private lazy var contentStackView = AppStackView([headerView, personalTableView], axis: .vertical, spacing: 10)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Properties
    let output: any PersonalViewOutput

    // MARK: - Init
    init(output: any PersonalViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PersonalViewController deinit")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
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
            self?.output.sendAction(.dismissButtonTapped)
        }
    }

    func setupPersonalTableViewAction() {
        personalTableView.onShowURL = { [weak self] in
            self?.output.sendAction(.showURLTapped)
        }
    }
}

// MARK: - PersonalViewInput
extension PersonalViewController: PersonalViewInput {
    // Настраиваем первоначальный экран (делаем настройку всех UI)
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    // Прячем контент и показываем спиннер
    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }

    // Показываем контент, обновляем UI c данными и прячем спиннер
    func configure(with profile: User) {
        isShowContent(true)
        updateUI(with: profile)
        activityIndicator.stopAnimating()
    }

    // В режиме ошибки прячем спиннер
    func showError() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Supporting methods
private extension PersonalViewController {
    func isShowContent(_ bool: Bool) {
        contentStackView.alpha = bool ? 1 : 0
    }

    // Обновляем UI c персональными данными
    func updateUI(with personalData: User) {
        personalTableView.getUserData(personalData)
    }
}
