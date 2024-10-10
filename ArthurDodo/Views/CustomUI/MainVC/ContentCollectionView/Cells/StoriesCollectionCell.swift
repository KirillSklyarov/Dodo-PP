//
//  StoriesCollectionCell.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 18.09.2024.
//

import UIKit

final class StoriesCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "StoriesCollectionCell"
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular12
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private var gradientLayer: CAGradientLayer?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        configGradient()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    // MARK: - Public methods
    func configureCell(_ story: StoriesModel) {
        let coverImage = UIImage(named: story.storyCoverImage)
        coverImageView.image = coverImage
        let storyDescription = story.storyDescription
        titleLabel.text = storyDescription
        designViewedStory(story)
    }

    func designViewedStory(_ story: StoriesModel) {
        let storyID = story.id
        let isViewed = UserDefaults.standard.isStoryViewed(storyID)
        if isViewed {
            containerView.alpha = 0.3
        } else {
            containerView.alpha = 1.0
        }
    }
}

// MARK: - Setup UI
private extension StoriesCollectionCell {
    func setupConstraints() {

        containerView.addSubviews(coverImageView, titleLabel)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])

        contentView.addSubviews(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configGradient() {
        let colors = AppColors()
        let randomColor = colors.getRandomColor()

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, randomColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = containerView.bounds
        containerView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
}
