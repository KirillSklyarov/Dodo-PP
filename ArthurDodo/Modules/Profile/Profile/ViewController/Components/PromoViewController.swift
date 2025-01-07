import UIKit

// Вылезающий снизу экран "Акции"
final class PromoViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var promoImageView = AppImageView(type: .promoImage)
    private lazy var promoDateLabel = AppLabel(type: .basicTitle, textColor: AppColors.grayFont)
    private lazy var promoDetailsLabel = AppLabel(type: .smallHeader)
    private lazy var legalTextLabel = AppLabel(type: .basicTitle, text: "Акция работает только в пиццерии при заказе в приложении. Не действует с другими акциями и при заказе с комбо. Примените до 13.10 включительно", textColor: AppColors.grayFont)

    private lazy var applyButton = AppButtons(type: .cartOrange, text: "Применить")

    private lazy var contentStack = setupContentStack()

    private let storage: PromoStorageProtocol

    // MARK: - Init
    init(storage: PromoStorageProtocol) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureViewController()
        setupActions()
    }

    // MARK: - Public methods
    func configureViewController() {
        guard let offer = storage.getSelectedPromo() else { print("No promo selected"); return }
        let image = UIImage(named: offer.imageName)
        promoImageView.image = image

        promoDateLabel.text = offer.date
        promoDetailsLabel.text = offer.details
    }
}

// MARK: - Setup Actions
extension PromoViewController {
    func setupActions() {
        setupButtonActions()
    }

    func setupButtonActions() {
        applyButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            applyButton.setNewTitle("Акция применена")
            applyButton.setNewBackgroundColor(AppColors.buttonGray)
        }
    }
}

// MARK: - Setup UI
private extension PromoViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(isSafeArea: true, allInsets: 10)
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
