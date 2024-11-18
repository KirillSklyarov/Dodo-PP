import UIKit
import SafariServices

final class PersonalViewController: UIViewController {

    // MARK: - Properties
    private lazy var headerView = CartHeaderView(title: "Личные данные") // Заголовок с кнопкой
    private lazy var personalTableView = PersonalTableView()

    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    var onDismissButtonTapped: (() -> Void)?
    
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
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(headerView, personalTableView)

        setupLayout()
    }

    func setupLayout() {
        setupHeaderViewLayout()
        setupPersonalTableViewLayout()
    }

    func setupHeaderViewLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
    }

    func setupPersonalTableViewLayout() {
        NSLayoutConstraint.activate([
            personalTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            personalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            personalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
            personalTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomInset)
        ])
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

// MARK: - Supporting methods
private extension PersonalViewController {
    func showURL() {
        guard let url = URL(string: "https://www.dodopizza.ru") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
