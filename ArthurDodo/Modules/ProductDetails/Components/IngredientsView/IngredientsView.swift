//
//  IngredientsView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

final class IngredientsView: UIView {

    // MARK: - Properties&Callbacks
    private let buttonSize: CGFloat = 24
    private let cornerRadius: CGFloat = 10
    private let topInset: CGFloat = 10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let bottomInset: CGFloat = -10

    private var item: Item?
    private let storage = DataStorage.shared

    var onShowPopupVC: ((UIViewController) -> Void)?

    // MARK: - UI Properties
    private lazy var ingredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.regular16
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "info.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.semibold16
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var ingredientsAndInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ingredientsLabel, infoButton])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ingredientsAndInfoStack, weightLabel])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var cpfcPopupView = CpfcPopupView(item: item)

    // MARK: - Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        fetchData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Fetch data from storage
private extension IngredientsView {
    func fetchData() {
        self.item = storage.getSelectedItemFromStorage()
    }
}

// MARK: - Public methods
extension IngredientsView {
    func updateIngredients(_ ingredients: String) {
        ingredientsLabel.text = ingredients
    }

    func updateWeight(_ weight: Int) {
        let text = "\(weight) г"
        weightLabel.text = text
    }

    func setProductDetails(_ details: WeightPrice) {
        cpfcPopupView.setProductDetails(details)
    }
}

// MARK: - Setup UI
private extension IngredientsView {
    func setupUI() {
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
        ])
    }
}

// MARK: - Setup actions
private extension IngredientsView {
    @objc private func infoButtonTapped() {
        showPopupView()
    }
}

// MARK: - Setup PopUpIngredientsView
 extension IngredientsView {
    func showPopupView() {
        setupPopupView()
        onShowPopupVC?(cpfcPopupView)
    }

    // Настраиваем откуда будет показываться экран и кто его источник (т.е. на какой вьюхе он будет показываться)
    func setupPopupView() {
        let sourceRect = CGRect(
            origin: CGPoint(x: infoButton.frame.minX - rightInset,
                            y: infoButton.frame.midY + topInset),
            size: .zero)
        cpfcPopupView.setupPopupView(sourceView: self, sourceRect: sourceRect)
    }
}

extension IngredientsView: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
