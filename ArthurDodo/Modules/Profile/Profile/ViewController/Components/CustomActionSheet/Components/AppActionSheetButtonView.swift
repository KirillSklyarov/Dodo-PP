import UIKit
import AppUIComponentsSPM

enum AppActionSheetButtonType {
    case chat
    case call
    case dismiss
}

final class AppActionSheetButtonView: UIView {

    // MARK: - Properties
    private let viewHeight: CGFloat = 60
    var actionSheetButton: AppButtons?
    var onButtonTapped: (() -> Void)?

    // MARK: - Init
    init(_ type: AppActionSheetButtonType) {
        super.init(frame: .zero)
        setupUI(type)
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppActionSheetButtonView {
    func setupUI(_ type: AppActionSheetButtonType) {
        let blurView = AppBlurView()

        switch type {
        case .chat:
            actionSheetButton = AppButtons(type: .actionSheetButton, text: "Написать в чат")
        case .call:
            actionSheetButton = AppButtons(type: .actionSheetButton, text: "Позвонить")
        case .dismiss:
            actionSheetButton = AppButtons(type: .actionSheetButton, text: "Отменить")
        }

        guard let actionSheetButton else { return }
        addSubviews(blurView, actionSheetButton)

        setupLayout(blurView, actionSheetButton)
    }

    func setupLayout(_ blurView: AppBlurView, _ cartButton: AppButtons) {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
        blurView.setConstraints()
        cartButton.setConstraints()
    }

    func setupActions() {
        actionSheetButton?.onButtonTapped = { [weak self] in
            guard let self else { print("Self is nil"); return }
            onButtonTapped?()
        }
    }
}
