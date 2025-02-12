import UIKit
import AppUIComponentsSPM

protocol PromoViewInput: BaseViewControllerInput where inputData == Promo {
    func updateUIWithAppliedPromo()
}

// Вылезающий снизу экран "Акции"
final class PromoViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var promoImageView = AppImageView(type: .promoImage)
    private lazy var promoDateLabel = AppLabel(type: .basicTitle, textColor: AppColors.grayFont)
    private lazy var promoDetailsLabel = AppLabel(type: .smallHeader)
    private lazy var legalTextLabel = AppLabel(type: .basicTitle, text: "Акция работает только в пиццерии при заказе в приложении. Не действует с другими акциями и при заказе с комбо. Примените до 13.10 включительно", textColor: AppColors.grayFont)

    private lazy var applyButton = AppButtons(type: .cartOrange, text: "Применить")

    private lazy var contentStack = setupContentStack()

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Output
    var output: any PromoViewOutput

    // MARK: - Init
    init(output: any PromoViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }
}

// MARK: - PromoViewInput
extension PromoViewController: PromoViewInput {
    // Делаем первоначальное состояние экрана
    func setupInitialState() {
        setupUI()
        setupActions()
    }

    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }
    
    func showError() {
        activityIndicator.stopAnimating()
    }

    func updateUIWithAppliedPromo() {
        applyButton.setNewTitle("Акция применена")
        applyButton.setNewBackgroundColor(AppColors.buttonGray)
    }

    func configure(with data: Promo) {
        isShowContent(true)
        updateUI(with: data)
    }
}

// MARK: - Setup Actions
extension PromoViewController {
    func setupActions() {
        setupButtonActions()
    }

    func setupButtonActions() {
        applyButton.onButtonTapped = { [weak self] in
            self?.output.sendAction(.applyPromo)
        }
    }
}

// MARK: - Setup UI
private extension PromoViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStack, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(isSafeArea: true, allInsets: 10)

        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func setupContentStack() -> UIStackView {
        let imageContainer: UIView = {
            let view = UIView()
            view.addSubviews(promoImageView)
            view.contentMode = .scaleAspectFit
            return view
        }()

        promoImageView.setLocalConstraints(top: 15, bottom: 0)
        promoImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor).isActive = true

        let contentStack = AppStackView([imageContainer, promoDateLabel, promoDetailsLabel, legalTextLabel, applyButton], axis: .vertical, distribution: .equalSpacing)

        return contentStack
    }
}

// MARK: - Supporting methods
private extension PromoViewController {
    func isShowContent(_ bool: Bool) {
        contentStack.alpha = bool ? 1 : 0
    }

    func updateUI(with data: Promo) {
        let image = UIImage(named: data.imageName)
        promoImageView.image = image
        promoDateLabel.text = data.date
        promoDetailsLabel.text = data.details
    }
}
