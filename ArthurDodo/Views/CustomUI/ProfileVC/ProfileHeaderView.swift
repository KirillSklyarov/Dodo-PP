//
//  ProfileHeaderView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 10.10.2024.
//

import UIKit

final class ProfileHeaderView: UIView {

    // MARK: - Properties
    private let buttonSize: CGFloat = 40
    private let viewHeight: CGFloat = 40

    private let leftPadding: CGFloat = 20
    private let rightPadding: CGFloat = -20

    // MARK: - Callbacks
    var onDismissButtonTapped: (() -> Void)?
    var onChatButtonTapped: (() -> Void)?
    var onProfileButtonTapped: (() -> Void)?

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView()
    private lazy var chatButton = ProfileButtonView(type: .chat)
    private lazy var profileButton = ProfileButtonView(type: .profile)
    private lazy var contentContainer = UIView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setupLayout()
        }
    }

    @objc private func profileButtonTapped() {
        onProfileButtonTapped?()
    }

    private func setupActions() {
        dismissButton.onDismissButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
        }

        chatButton.onButtonTapped = { [weak self] in
            self?.onChatButtonTapped?()
        }

        profileButton.onButtonTapped = { [weak self] in
            self?.onProfileButtonTapped?()
        }
    }

    // MARK: - Private methods
    private func setupLayout() {
        guard let superview else { print("You must add HeaderView to a view before setting up layout"); return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leftPadding),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: rightPadding),
            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }

    private func setupUI() {
        addSubviews(contentContainer)

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupContentContainer()
    }

    private func setupContentContainer() {
        contentContainer.addSubviews(dismissButton, chatButton, profileButton)

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor),

            profileButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),

            chatButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            chatButton.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -10)
        ])
    }
}
