import UIKit

final class FinalVC: UIViewController {

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ успешно оформлен"
        label.textColor = .white
        label.font = AppFonts.bold34
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var doneImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "checkmark.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.image = image
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        view.addSubviews(doneImageView)
        view.contentMode = .scaleAspectFill
        view.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageViewContainer, titleLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    // MARK: - Properties
    private let imageSize: CGFloat = 100
    private let leftInset: CGFloat = 20
    private let rightInset: CGFloat = -20
    private let topInset: CGFloat = 20

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
}

// MARK: - Setup UI
private extension FinalVC {
    func setupActions() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            self?.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
}

// MARK: - Setup UI
private extension FinalVC {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundBlack
        view.addSubviews(dismissButton, contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupDismissButtonViewLayout()
        setupImageViewContainerLayout()
        setupContentStackLayout()
    }

    func setupDismissButtonViewLayout() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topInset),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
        ])
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightInset),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupImageViewContainerLayout() {
        NSLayoutConstraint.activate([
            doneImageView.centerXAnchor.constraint(equalTo: imageViewContainer.centerXAnchor),
            doneImageView.centerYAnchor.constraint(equalTo: imageViewContainer.centerYAnchor)
        ])
    }
}

//MARK: - SwiftUI
import SwiftUI
struct ProviderFinal : PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }

    struct ContainterView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return FinalVC()
        }

        typealias UIViewControllerType = UIViewController


        let viewController = FinalVC()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ProviderFinal.ContainterView>) -> FinalVC {
            return viewController
        }

        func updateUIViewController(_ uiViewController: ProviderFinal.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ProviderFinal.ContainterView>) {

        }
    }
}
