import UIKit

final class PromoStackView: UIStackView {

    // MARK: - UI Properties
    private lazy var promoHeaderView = OrderView(title: "Акции")
    private lazy var promoCollectionView = PromoCollectionView()
    private lazy var pageControl = CustomPageControl()
    private lazy var skeletonView = SkeletonView()

    // MARK: - Other Properties
    private let leftPadding: CGFloat = 0
    private let rightPadding: CGFloat = 0
    private let cornerRadius: CGFloat = 10

    private var state: ScreenState = .loading

    var onPromoSelected: ((Promo) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
        showScreenWithState()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension PromoStackView {
    // Передаем коллекции полученные акции (нам незачем себе их оставлять) и обновляем UI
    func updateUI(_ promo: [Promo]) {
        promoCollectionView.updateUI(promo)
    }

    // Позволяет установить состояние стека и показывать тот или иной вид в зависимости от экрана
    func setState(_ state: ScreenState) {
        self.state = state
        showScreenWithState()
    }
}

// MARK: - Setup Actions
private extension PromoStackView {
    func setupActions() {
        setupPromoCollectionViewActions()
    }

    func setupPromoCollectionViewActions() {
        promoCollectionView.onShowNewCell = { [weak self] pageNumber in
            self?.pageControl.currentPage = pageNumber
        }

        promoCollectionView.onCellSelected = { [weak self] specialOffer in
            self?.onPromoSelected?(specialOffer)
        }
    }
}

// MARK: - Setup UI
private extension PromoStackView {
    // Базовые настройки стека
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        axis = .vertical
        spacing = 10
    }

    // Метод определяет что показывать в зависимости от состояния стека
    func showScreenWithState() {
        switch state {
        case .loading: showSkeleton()
        case .success: showSuccessScreen()
        case .error: break
        }
    }

    // Настраиваем как показывать скелетон
    func showSkeleton() {
        addArrangedSubview(skeletonView)
    }

    // Настраиваем показ загруженного экрана
    func showSuccessScreen() {
        skeletonView.removeFromSuperview()
        addArrangedSubview(promoHeaderView)
        addArrangedSubview(promoCollectionView)
        addArrangedSubview(pageControl)
    }
}
