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
    private let progressViewHeight: CGFloat = 2
    private var currentStoryIndex = 0
    private var countSubStories = 0
    private var subStoryIndex = 0
    private var currentSubStoryIndex = 0

    // MARK: - Timer properties
    private var timer: Timer?
    private lazy var elapsedTime: TimeInterval = 0.0
    private lazy var interval: TimeInterval = 0.05
    private lazy var durationOfStory: TimeInterval = 2.0

    // MARK: - UI Properties
    private lazy var dismissButton = DismissButtonView(xColor: AppColors.buttonGray, backgroundColor: .white)
    private lazy var storiesImageView: UIImageView = {
        let imageView = UIImageView()
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
    }

    deinit {
        timer?.invalidate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IB Actions
    @objc private func updateProgress(_ timer: Timer) {
        guard let subStoryIndex = timer.userInfo as? Int,
              subStoryIndex < progressViews.count else { return }

        elapsedTime += interval
        let progress = Float(elapsedTime / durationOfStory)
        progressViews[subStoryIndex].setProgress(progress, animated: true)

        if elapsedTime >= durationOfStory {
            currentSubStoryIndex += 1
            showSubStory(currentSubStoryIndex)
        }
    }

    @objc private func onTap(_ sender: UITapGestureRecognizer) {
        setupTapGesture(sender)
    }
}

// MARK: - Data binding
extension BackgroundStoriesView {
    private func dataBinding() {
        dismissButtonTapped()
    }

    private func dismissButtonTapped() {
        dismissButton.onCloseButtonTapped = { [weak self] in
            guard let self else { return }
            onDismissButtonTapped?()
            timer?.invalidate()
        }
    }
}

// MARK: - Setup Stories
extension BackgroundStoriesView {
    func showSelectedStory(_ indexPath: IndexPath) {
        currentStoryIndex = indexPath.row
        countSubStories = stories[currentStoryIndex].storyImages.count
        showStory()
    }

    private func showStory() {
        setupProgressViews()
        currentSubStoryIndex = 0
        showSubStory(currentSubStoryIndex)
    }

    private func showSubStory(_ subStoryIndex: Int) {
        if subStoryIndex < countSubStories {
            setStoryImage(subStoryIndex)
            elapsedTime = 0.0
            progressViews[subStoryIndex].progress = 0.0
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateProgress), userInfo: subStoryIndex, repeats: true)
        } else {
            showNextStory()
        }
    }

    private func setStoryImage(_ index: Int) {
        let storyToShow = stories[currentStoryIndex]
        guard index < storyToShow.storyImages.count else { return }
        let imageName = storyToShow.storyImages[index]
        let image = UIImage(named: imageName)
        storiesImageView.image = image
    }

    private func setupTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        if location.x < bounds.width / 2 {
            showPreviousStory()
        } else {
            showNextStory()
        }
    }

    // Либо показываем предыдущую Мини-Историю, либо последнюю Мини-историю предыдущей истории, либо предыдущую историю
    private func showPreviousStory() {
        if currentSubStoryIndex != 0 {
            clearProgressView()
            currentSubStoryIndex -= 1
            showSubStory(currentSubStoryIndex)
        } else if currentStoryIndex != 0 {
            currentStoryIndex -= 1
            showLastSubStory()
        } else {
            showStory()
        }
    }

    // Когда мы возвращаемся на предыдущую сторис, но тут делаем чтобы мы вернулись на последнюю Мини-Историю предыдущей истории
    private func showLastSubStory() {
        countSubStories = stories[currentStoryIndex].storyImages.count
        currentSubStoryIndex = countSubStories - 1
        setupProgressViews()
        fillAllProgressViewsExceptLast()
        showSubStory(currentSubStoryIndex)
    }

    // Либо показываем следующую Мини-Историю, либо следующую Историю, либо закрываем окно
    private func showNextStory() {
        if currentSubStoryIndex < countSubStories - 1 {
            fillProgressView()
            currentSubStoryIndex += 1
            showSubStory(currentSubStoryIndex)
        } else if currentStoryIndex != stories.count - 1 {
            currentStoryIndex += 1
            countSubStories = stories[currentStoryIndex].storyImages.count
            showStory()
        } else {
            onDismissButtonTapped?()
        }
    }

    // Мгновенно закрашиваем прогресс
    private func fillProgressView() {
        timer?.invalidate()
        progressViews[currentSubStoryIndex].setProgress(1.0, animated: false)
    }

    // Мгновенно закрашиваем все прогрессы кроме последнего
    private func fillAllProgressViewsExceptLast() {
        for view in progressViews {
            if view != progressViews.last {
                timer?.invalidate()
                view.setProgress(1.0, animated: false)
            }
        }
    }

    // Мгновенно обнуляем прогресс вью
    private func clearProgressView() {
        timer?.invalidate()
        progressViews[currentSubStoryIndex].setProgress(0.0, animated: false)
    }
}

// MARK: - SetupUI
private extension BackgroundStoriesView {

    func setupProgressViews() {
        progressViewsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        progressViews = []
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
