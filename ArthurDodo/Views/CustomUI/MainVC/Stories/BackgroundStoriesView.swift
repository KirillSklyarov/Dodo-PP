//
//  BackgroundStoriesView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 07.10.2024.
//

import UIKit

final class BackgroundStoriesView: UIView {

    var onDismissButtonTapped: (() -> Void)?
    private let padding: CGFloat = 10
    private let progressViewHeight: CGFloat = 4

    // MARK: - Timer properties
    private var timer: Timer?
    private lazy var elapsedTime: TimeInterval = 0.0
    private lazy var interval: TimeInterval = 0.05

    private lazy var dismissButton = DismissButtonView(xColor: AppColors.buttonGray, backgroundColor: .white)
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progress = 0.0
        progressView.heightAnchor.constraint(equalToConstant: progressViewHeight).isActive = true
        return progressView
    }()
    private lazy var storiesImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "1")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        dataBinding()
        showStories()
    }

    deinit {
        timer?.invalidate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func dataBinding() {
        dismissButtonTapped()
    }

    private func dismissButtonTapped() {
        dismissButton.onCloseButtonTapped = { [weak self] in
            self?.onDismissButtonTapped?()
            self?.timer?.invalidate()
        }
    }

    private func showStories() {
        elapsedTime = 0.0
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }

    @objc private func updateProgress() {
        elapsedTime += interval
        progressView.progress = Float(elapsedTime / 10.0)

        if elapsedTime >= 10.0 {
            timer?.invalidate()
            onDismissButtonTapped?()
        }
    }

    private func setupUI() {
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = 20
        layer.masksToBounds = true

        addSubviews(storiesImageView, progressView, dismissButton)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            storiesImageView.topAnchor.constraint(equalTo: topAnchor),
            storiesImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            storiesImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            storiesImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressView.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            progressView.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -padding),

            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}
