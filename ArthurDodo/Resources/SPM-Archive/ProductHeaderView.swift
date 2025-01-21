//import UIKit
//import AppUIComponentsSPM
//
//// Enum размеров header (для экрана itemDetails нужен большой, а для экрана itemEdit нужен маленький)
//enum ProductHeaderViewType {
//    case itemDetails
//    case itemEdit
//}
//
//// Заблюренный header на экране Product Details (и на EditProduct)
//final class ProductHeaderView: UIView {
//
//    // MARK: - UI Properties
//    private lazy var titleLabel = AppLabel(type: .smallHeader, alignment: .center, numberOfLines: 0)
//    private lazy var dismissButton = AppDismissButtonView(type: .standard)
//    private lazy var blurView = AppBlurView()
//
//    private lazy var contentStackView = setupContentStackView()
//
//    // MARK: - Properties
//    private var heightConstraint: NSLayoutConstraint?
//
//    var onDismissButtonTapped: (() -> Void)?
//
//    // MARK: - Init
//    init(frame: CGRect = .zero, type: ProductHeaderViewType) {
//        super.init(frame: frame)
//        setupUI()
//        setupActions()
//        setViewHeight(type)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - Public methods
//extension ProductHeaderView {
//    func updateTitle(_ title: String) {
//        titleLabel.text = title
//    }
//}
//
//// MARK: - Setup actions
//private extension ProductHeaderView {
//    func setupActions() {
//        dismissButtonTapped()
//    }
//
//    func dismissButtonTapped() {
//        dismissButton.onButtonTapped = { [weak self] in
//            self?.onDismissButtonTapped?()
//        }
//    }
//}
//
//// MARK: - Setup UI
//private extension ProductHeaderView {
//    func setupUI() {
//        configureTitleLabel()
//
//        addSubviews(blurView)
//
//        blurView.contentView.addSubviews(contentStackView)
//
//        setupLayout()
//
//    }
//
//    // Делаем для тайтла изменяемый размер, чтобы он подстраивался если название длинное (например, у коктейлей)
//    func configureTitleLabel() {
//        titleLabel.adjustsFontSizeToFitWidth = true
//    }
//
//    func setupLayout() {
//        setupBlurConstraints()
//        setupContentStackLayout()
//    }
//
//    func setupBlurConstraints() {
//        blurView.setConstraints()
//    }
//
//    func setupContentStackLayout() {
//        contentStackView.setLocalConstraints(bottom: 10, left: 10, right: 50)
//    }
//
//    func setupContentStackView() -> UIStackView {
//        let contentStackView = AppStackView([dismissButton, titleLabel], axis: .horizontal, spacing: 10)
//        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        return contentStackView
//    }
//}
//
//// MARK: - Supporting methods
//private extension ProductHeaderView {
//    // Метод позволяет менять высоту у вью (сначала выключаем текущий констреинт, определяем правильную высоту, потом выставляем констреинт и активируем его). Так как мы используем две разные высоты (для Product details у нас большая высота - 110, а для экрана EditProduct - 60), то и в этом методе мы можем менять высоту передавая туда параметр
//    func setViewHeight(_ height: ProductHeaderViewType) {
//        heightConstraint?.isActive = false
//
//        switch height {
//        case .itemEdit: heightConstraint = heightAnchor.constraint(equalToConstant: 60)
//        case .itemDetails: heightConstraint = heightAnchor.constraint(equalToConstant: 110)
//        }
//
//        heightConstraint?.isActive = true
//    }
//}
