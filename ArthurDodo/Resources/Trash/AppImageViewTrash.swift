//import UIKit
//
//final class AppImageView: UIImageView {
//
//    init(frame: CGRect = .zero, viewImage: AppImages? = nil, isSystem: Bool = true, tintColor: AppColorsEnum? = nil, squareSize: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil, isHidden: Bool = false, cornerRadius: CGFloat? = nil) {
//        super.init(frame: frame)
//        contentMode = .scaleAspectFill
//        self.isHidden = isHidden
//        image = setupUI(viewImage: viewImage, isSystem: isSystem, tintColor: tintColor)
//        setupLayout(squareSize)
//        setupHeight(height)
//        setupWidth(width)
//        setCornerRadius(cornerRadius)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//private extension AppImageView {
//    // Настраиваем картинку, если она нужна (если isSystem = true, то это системная картинка, если нет, то обычная)
//    func setupUI(viewImage: AppImages?, isSystem: Bool, tintColor: AppColorsEnum?) -> UIImage? {
//        let image: UIImage?
//        guard let viewImage else { return nil }
//
//        if isSystem {
//            guard let tintColor else { print("No tint color"); return nil }
//            image = UIImage(systemName: viewImage.image)?.withTintColor(tintColor.color, renderingMode: .alwaysOriginal)
//        } else {
//            image = UIImage(named: viewImage.image)
//        }
//
//        return image
//    }
//
//    // Если картинка квадратная, то тут выставляем размер
//    func setupLayout(_ squareSize: CGFloat?) {
//        if let squareSize {
//            heightAnchor.constraint(equalToConstant: squareSize).isActive = true
//            widthAnchor.constraint(equalToConstant: squareSize).isActive = true
//        }
//    }
//
//    func setupHeight(_ height: CGFloat?) {
//        if let height {
//            heightAnchor.constraint(equalToConstant: height).isActive = true
//        }
//    }
//
//    func setupWidth(_ width: CGFloat?) {
//        if let width {
//            widthAnchor.constraint(equalToConstant: width).isActive = true
//        }
//    }
//
//    func setIsHidden(_ isHidden: Bool) {
//        self.isHidden = isHidden
//    }
//
//    func setCornerRadius(_ cornerRadius: CGFloat?) {
//        if let cornerRadius {
//            layer.cornerRadius = cornerRadius
//            clipsToBounds = true
//        }
//    }
//}

// MARK: - Setup navigation bar
//private extension ProfileViewController {
//    func setupNavigationBar() {
//        let dismissButtonView = DismissButtonView()
//        let chatButtonView = ProfileButtonView(type: .chat)
//        let profileButtonView = ProfileButtonView(type: .profile)
//
//        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.barTintColor = AppColors.backgroundBlack
//        navigationController?.navigationBar.backgroundColor = AppColors.backgroundBlack
//        navigationController?.navigationBar.isTranslucent = false
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButtonView)
//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(customView: profileButtonView),
//            UIBarButtonItem(customView: chatButtonView)
//        ]
//
//        // Настраиваем действия кнопок навигации
//        setupNavigationViewActions(dismissButtonView, chatButtonView, profileButtonView)
//    }
//
//    // Настройка действий навигации
//    func setupNavigationViewActions(_ dismissButtonView: DismissButtonView, _ chatButtonView: ProfileButtonView, _ profileButtonView: ProfileButtonView) {
//
//        dismissButtonView.onButtonTapped = { [weak self] in
//            self?.dismissVC()
//        }
//
//        chatButtonView.onButtonTapped = { [weak self] in
//            self?.showChatAlert()
//        }
//
//        profileButtonView.onButtonTapped = { [weak self] in
//            self?.showPersonalVC()
//        }
//    }
//}
