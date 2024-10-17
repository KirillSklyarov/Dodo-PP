//
//  CustomActionSheet.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 17.10.2024.
//

import UIKit

final class CustomActionSheet: UIViewController {

    // MARK: - UI Properties
    private lazy var callButton = ActionSheetButton(title: "Позвонить")
    private lazy var chatButton = ActionSheetButton(title: "Написать в чат")
    private lazy var dismissButton = ActionSheetButton(title: "Отменить", roundedCorners: true)

    private lazy var callAndChatStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [callButton, chatButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        return stack
    }()
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [callAndChatStack, dismissButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        return stack
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.buttonGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    private lazy var contentContainer: UIView = {
        let view = UIView()
        view.addSubviews(contentStack)
        return view
    }()

    private var bottomConstraint: NSLayoutConstraint!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showActionSheet()
    }

    func showActionSheet() {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Setup Actions
private extension CustomActionSheet {
    func setupAction() {
        dismissButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            moveDownContentContainer()
            dismiss(animated: true)
        }

        chatButton.onButtonTapped = {
            print(#function)
        }

        callButton.onButtonTapped = { 
            print(#function)
        }
    }

    // Плавно закрываем окно вниз
    func moveDownContentContainer() {
        bottomConstraint.constant = 250
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Setup UI
private extension CustomActionSheet {
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubviews(contentContainer, separatorView)

        setupLayout()
        setupGesture()
    }

    func setupLayout() {
        contentContainerLayout()
        contentStackLayout()
        separatorLayout()
    }

    func contentContainerLayout() {
        bottomConstraint =  contentContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 250)
        bottomConstraint.isActive = true

        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
        ])
    }

    func separatorLayout() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: callButton.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: callButton.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: callButton.trailingAnchor)
        ])
    }

    func contentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 10),
            contentStack.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -10),
            contentStack.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -10),
        ])
    }
}

// MARK: - Setup Gesture
private extension CustomActionSheet {
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    // Окно закрывается, если нажали не на кнопки
    @objc private func viewTapped() {
        moveDownContentContainer()
        dismiss(animated: true)
    }
}
