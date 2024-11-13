import UIKit
import SafariServices

final class PersonalViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var personalTableView = PersonalTableView()

    private let router: Router

    // MARK: - Init
    init(router: Router) {
        self.router = router
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
    }
}

// MARK: - Setup UI
private extension PersonalViewController {
    func setupUI() {
        setupNavigationBar()
        title = "Настройки"
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(personalTableView)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            personalTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            personalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            personalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            personalTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.backgroundColor = AppColors.backgroundGray

        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = AppColors.buttonOrange
        doneButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc func doneButtonTapped() {
        router.dismissCurrentVC()
    }
}

// MARK: - Setup Actions
private extension PersonalViewController {
    func setupActions() {
        personalTableView.onShowURL = { [weak self] in
            self?.showURL()
        }
    }

    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
