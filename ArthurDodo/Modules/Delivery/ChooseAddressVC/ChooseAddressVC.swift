import UIKit

final class ChooseAddressVC: UIViewController {

    // MARK: - UI Properties
    private lazy var addressTableView = AddressListTableView2()

    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    private let storage = DataStorage.shared

    var onAddressCellTapped: ((String) -> Void)?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
        setupActions()
    }
}

// MARK: - Fetch Data
private extension ChooseAddressVC {
    func fetchData() {
        if storage.isAddressesEmpty() {
            storage.fetchUserAddresses()
            storage.onDataFetchedSuccessfully = { [weak self] addresses in
                guard let self else { return }
                addressTableView.updateUI(with: addresses)
            }
        } else {
            let addresses = storage.fetchedUserAddresses
            addressTableView.updateUI(with: addresses)
        }
    }
}

// MARK: - Setup UI
private extension ChooseAddressVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(addressTableView)

        setupNavigationBar()
        setupLayout()
    }

    func setupNavigationBar() {
        navigationItem.title = "Адреса доставки"

        navigationController?.navigationBar.barTintColor = AppColors.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let dismissButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = AppColors.buttonOrange
        dismissButton.setTitleTextAttributes([NSAttributedString.Key .font: AppFonts.semibold18], for: .normal)
        navigationItem.leftBarButtonItem = dismissButton
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            addressTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addressTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            addressTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
        ])
    }
}

// MARK: - Setup Actions
private extension ChooseAddressVC {
    func setupActions() {
        setupAddressTableViewActions()
    }

    func setupAddressTableViewActions() {
        addressTableView.onAddressCellTapped = { [weak self] addressName in
            guard let self else { return }
            onAddressCellTapped?(addressName)
            dismiss(animated: true)
        }
    }

    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderChooseAddressVC : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return ChooseAddressVC()
        }

        typealias UIViewControllerType = UIViewController


        let viewController = ChooseAddressVC()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderChooseAddressVC.ContainterView>) -> ChooseAddressVC {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderChooseAddressVC.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderChooseAddressVC.ContainterView>) {

        }
    }
}
