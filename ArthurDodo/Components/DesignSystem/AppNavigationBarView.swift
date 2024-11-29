import UIKit

enum AppNavigationBarViewType {
    case personal
    case delivery
    case chooseAddress
    case payment
    case cart
}

final class AppNavigationBarView: UIView {

    // MARK: - Properties
    var headerView: AppNavigationHeaderView?
    var onDismissButtonTapped: (() -> Void)?

    // MARK: - Init
    init(type: AppNavigationBarViewType) {
        super.init(frame: .zero)
        configure(type)
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppNavigationBarView {
    func configure(_ type: AppNavigationBarViewType) {
        switch type {
        case .personal:
            headerView = AppNavigationHeaderView(title: "Личные данные")
        case .delivery:
            headerView = AppNavigationHeaderView(title: "Доставка")
        case .chooseAddress:
            headerView = AppNavigationHeaderView(title: "Адреса доставки")
        case .payment:
            headerView = AppNavigationHeaderView(title: "Оплата")
        case .cart:
            headerView = AppNavigationHeaderView(title: "Корзина")
        }

        guard let headerView else { return }
        addSubviews(headerView)
        setupLayout(headerView)
    }

    func setupAction() {
        headerView?.onDismissButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }
    }
}

// MARK: - Supporting methods
private extension AppNavigationBarView {
    func setupLayout(_ view: AppNavigationHeaderView?) {
        guard let view else { return }
        view.setConstraints()
    }
}
