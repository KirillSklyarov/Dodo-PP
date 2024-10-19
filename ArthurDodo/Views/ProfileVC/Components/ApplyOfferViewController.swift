//
//  ApplyOfferViewController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import UIKit

final class ApplyOfferViewController: UIViewController {

    // MARK: - Properties
    private let imageSize: CGFloat = 180
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -10
    private let topPadding: CGFloat = 10
    private let bottomPadding: CGFloat = -10

    // MARK: - UI Properties
    private lazy var specialOfferImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.addSubviews(specialOfferImageView)
        specialOfferImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        specialOfferImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    private lazy var dateOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold16
        label.textColor = AppColors.grayFont
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "до 13 октября"
        return label
    }()
    private lazy var detailsOfOfferLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold20
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Скидка 30% при заказе от 649 ₽"

        return label
    }()
    private lazy var legalTextLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular16
        label.textColor = AppColors.grayFont
        label.textAlignment = .left
        label.text = "Акция работает только в пиццерии при заказе в приложении. Не действует с другими акциями и при заказе с комбо. Примените до 13.10 включительно"
        label.numberOfLines = 0
        return label
    }()
    private lazy var applyButton = CartButton(isHidden: false, title: "Применить", isCart: false)
    private lazy var contentStack = setupContentStack()

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

    func setupContentStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [dateOfferLabel, detailsOfOfferLabel, legalTextLabel, applyButton])
        stack.axis = .vertical
        stack.distribution = .equalSpacing

        let finalStack = UIStackView(arrangedSubviews: [imageContainer, stack])
        finalStack.axis = .vertical
        finalStack.distribution = .fillEqually
        return finalStack
    }
}
