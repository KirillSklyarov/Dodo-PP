import UIKit

final class ApplyOfferViewController: UIViewController {

    // MARK: - Properties
    private let imageSize: CGFloat = 180
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10
    private let cornerRadius: CGFloat = 14

    // MARK: - UI Properties
    private lazy var specialOfferImageView = AppImageView(squareSize: imageSize, cornerRadius: cornerRadius)
   
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.addSubviews(specialOfferImageView)
        specialOfferImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        specialOfferImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()

    private lazy var dateOfferLabel = AppLabelDS(type: .promoTitle, text: "до 13 октября")
    private lazy var detailsOfOfferLabel = AppLabelDS(type: .orderStatus, text: "Скидка 30% при заказе от 649 ₽")
    private lazy var legalTextLabel = AppLabelDS(type: .promoTitle, text: "Акция работает только в пиццерии при заказе в приложении. Не действует с другими акциями и при заказе с комбо. Примените до 13.10 включительно")

    private lazy var applyButton = CartButton(isHidden: false, title: "Применить", isCart: false)

    private lazy var detailsStack = AppStackView([dateOfferLabel, detailsOfOfferLabel, legalTextLabel, applyButton], axis: .vertical, distribution: .equalSpacing)

    private lazy var contentStack = AppStackView([imageContainer, detailsStack], axis: .vertical, distribution: .fillEqually)

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
        specialOfferImageView.image = image

        dateOfferLabel.text = offer.date
        detailsOfOfferLabel.text = offer.details
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
            applyButton.configuration?.background.backgroundColor = AppColors.buttonGray
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
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topPadding),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightPadding),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomPadding)
        ])
    }
}
