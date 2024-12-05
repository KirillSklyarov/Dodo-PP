import UIKit

// Вылезающий снизу экран "Акции"
final class ApplyOfferViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var promoImageView = AppImageView(type: .promoImage)
    private lazy var promoDateLabel = AppLabel(type: .basicTitle, text: "до 13 октября", textColor: AppColors.grayFont)
    private lazy var promoDetailsLabel = AppLabel(type: .smallHeader, text: "Скидка 30% при заказе от 649 ₽")
    private lazy var legalTextLabel = AppLabel(type: .basicTitle, text: "Акция работает только в пиццерии при заказе в приложении. Не действует с другими акциями и при заказе с комбо. Примените до 13.10 включительно", textColor: AppColors.grayFont)

    private lazy var applyButton = AppButtons(type: .cartOrange, text: "Применить")

    private lazy var contentStack = setupContentStack()

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 20
    private let bottomPadding: CGFloat = -10

    // MARK: - Init
    init(with offer: Promo) {
        super.init(nibName: nil, bundle: nil)
        configureViewController(offer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }

    // MARK: - Public methods
    func configureViewController(_ offer: Promo) {
        let image = UIImage(named: offer.imageName)
        promoImageView.image = image

        promoDateLabel.text = offer.date
        promoDetailsLabel.text = offer.details
    }
}

// MARK: - Setup Actions
extension ApplyOfferViewController {
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
private extension ApplyOfferViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding),

//            promoImageView.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.4),
//            promoImageView.heightAnchor.constraint(equalTo: promoImageView.widthAnchor),
        ])
    }

    func setupContentStack() -> UIStackView {
        let detailsStack = AppStackView([promoDateLabel, promoDetailsLabel, legalTextLabel, applyButton], axis: .vertical, distribution: .equalSpacing)

        let imageStack = AppStackView([promoImageView], axis: .vertical, alignment: .center)

        let contentStack = AppStackView([imageStack, detailsStack], axis: .vertical, spacing: 10)

        return contentStack
    }
}
