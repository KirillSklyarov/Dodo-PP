import UIKit

final class StoriesCollectionCell: UICollectionViewCell {

    // MARK: - UI Properties
    private lazy var coverImageView = AppImageView(type: .stories)
    private lazy var titleLabel = AppLabel(type: .smallTitle)

    // MARK: - Properties
    private let cornerRadius: CGFloat = 14

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(_ story: Story) {
        let coverImage = UIImage(named: story.coverImage)
        coverImageView.image = coverImage
        let storyDescription = story.description
        titleLabel.text = storyDescription
        designViewedStory(story)
    }

    func designViewedStory(_ story: Story) {
        let storyID = story.id
        let isViewed = UserDefaults.standard.isStoryViewed(storyID)
        if isViewed {
            contentView.alpha = 0.35
        } else {
            contentView.alpha = 1.0
        }
    }
}

// MARK: - Setup UI
private extension StoriesCollectionCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        backgroundColor = .black

        contentView.addSubviews(coverImageView, titleLabel)

        setupLayout()
    }

    func setupLayout() {
        setupCoverImageLayout()
        setupTitleLabelLayout()
    }

    func setupCoverImageLayout() {
        coverImageView.setConstraints()
    }

    func setupTitleLabelLayout() {
        titleLabel.setLocalConstraints(bottom: 10, left: 10, right: 10)
    }
}
