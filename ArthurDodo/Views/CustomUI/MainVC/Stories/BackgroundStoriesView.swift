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
    var currentStoryIndex = 0
    var countSubStories = 0

    // MARK: - Timer properties
    private var timer: Timer?
    private lazy var elapsedTime: TimeInterval = 0.0
    private lazy var interval: TimeInterval = 0.05
    private lazy var durationOfStory: TimeInterval = 4.0

    private lazy var dismissButton = DismissButtonView(xColor: AppColors.buttonGray, backgroundColor: .white)
    private lazy var storiesImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "1")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var progressViewsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var progressViews: [UIProgressView] = []

    // MARK: - Init
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

    // MARK: - IB Actions
    @objc private func updateProgress(_ timer: Timer) {
        let index = timer.userInfo as? Int ?? 0
        let progressView = progressViews[index]
        elapsedTime += interval
        progressView.progress = Float(elapsedTime / durationOfStory)

        if elapsedTime >= durationOfStory {
            timer.invalidate()
            showNextStory()
        }
    }

    @objc private func onTap(_ sender: UITapGestureRecognizer) {
        setupTapGesture(sender)
    }

    // MARK: - Public methods
    func showStories(_ indexPath: IndexPath) {
        currentStoryIndex = indexPath.row
        countSubStories = stories[currentStoryIndex].storyImages.count
        showStories()
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
        if countSubStories == 1 {
            print("Here")
            setupProgressViews()
            let storyToShow = stories[currentStoryIndex]
            let image = UIImage(named: storyToShow.storyImages.first!)
            storiesImageView.image = image

            elapsedTime = 0.0
            guard let progressView = progressViews.first else { return }
            progressView.progress = 0.0
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateProgress), userInfo: progressView, repeats: true)
        } else {
            setupProgressViews()
            for i in progressViews.indices {
                let storyToShow = stories[currentStoryIndex].storyImages[i]
                let image = UIImage(named: storyToShow)
                storiesImageView.image = image
                timer?.invalidate()

                let progressView = progressViews[i]
                elapsedTime = 0.0
                progressView.progress = 0.0
                timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            }
        }
    }

    private func setupTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if location.x < bounds.width / 2 {
            showPreviousStory()
        } else {
            showNextStory()
        }
    }

    private func showPreviousStory() {
        if currentStoryIndex != 0 {
            currentStoryIndex -= 1
            startStory()
        } else {
            startStory()
        }
    }

    private func showNextStory() {
        if currentStoryIndex != stories.count - 1 {
            currentStoryIndex += 1
            countSubStories = stories[currentStoryIndex].storyImages.count
            startStory()
        } else {
            onDismissButtonTapped?()
        }
    }

    private func startStory() {
        timer?.invalidate()
        showStories()
    }
}

// MARK: - SetupUI
private extension BackgroundStoriesView {

    func setupProgressViews() {
        progressViewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        progressViews = []

        let currentStory = stories[currentStoryIndex]
        print(currentStory.storyImages.indices)
        for _ in 0..<countSubStories {
            let progressView = AppProgressView()
            progressViewsStack.addArrangedSubview(progressView)
            progressViews.append(progressView)
        }
    }

    func setupUI() {
        backgroundColor = AppColors.buttonGray
        layer.cornerRadius = 20
        layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(gesture)

        addSubviews(storiesImageView, progressViewsStack, dismissButton)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            storiesImageView.topAnchor.constraint(equalTo: topAnchor),
            storiesImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            storiesImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            storiesImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            progressViewsStack.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            progressViewsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            progressViewsStack.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -padding),

            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}
