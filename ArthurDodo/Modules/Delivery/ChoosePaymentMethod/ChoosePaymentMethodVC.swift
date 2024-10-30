import UIKit

final class ChoosePaymentMethodVC: UIViewController {

    // MARK: - Properties
    private lazy var paymentMethodsTableView = PaymentAddressesTableView(preferredPaymentMethod: preferredPaymentMethod)
    private let userDefaults = UserDefaults.standard
    private lazy var storage = DataStorage.shared

    var preferredPaymentMethod: PaymentMethod = .cbp

    var onPaymentMethodSelected: ((PaymentMethod) -> Void)?

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        fetchPreferredPaymentMethod()
    }

    func fetchPreferredPaymentMethod() {
        self.preferredPaymentMethod = storage.getPreferredPaymentMethodFromStorage()
        paymentMethodsTableView.updatePreferredPaymentMethod(preferredPaymentMethod)
    }
}

// MARK: - Supporting methods
private extension ChoosePaymentMethodVC {
    func checkPreferredPaymentMethod() {
        if let preferredPaymentMethod = userDefaults.string(forKey: "preferredPaymentMethod") {
            print("We have a preferred payment method: \(preferredPaymentMethod)")
        } else {
            print("We have NO preferred payment method")
        }
    }
}

// MARK: - Setup UI
private extension ChoosePaymentMethodVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(paymentMethodsTableView)

        setupNavigationBar()
        setupLayout()
    }

    func setupNavigationBar() {
        title = "Оплата"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = AppColors.buttonOrange
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            paymentMethodsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            paymentMethodsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentMethodsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - Setup actions
private extension ChoosePaymentMethodVC {
    func setupActions() {
        setupPaymentMethodsTableAction()
    }

    func setupPaymentMethodsTableAction() {
        paymentMethodsTableView.onPaymentMethodTapped = { [weak self]
            paymentMethod in
            guard let self else { return }
            onPaymentMethodSelected?(paymentMethod)
            navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderChoosePaymentMethod : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return ChoosePaymentMethodVC()
        }

        typealias UIViewControllerType = UIViewController


        let viewController = ChoosePaymentMethodVC()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderChoosePaymentMethod.ContainterView>) -> ChoosePaymentMethodVC {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderChoosePaymentMethod.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderChoosePaymentMethod.ContainterView>) {

        }
    }
}
