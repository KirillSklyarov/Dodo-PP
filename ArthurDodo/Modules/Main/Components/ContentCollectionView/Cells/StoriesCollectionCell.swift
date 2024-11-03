import UIKit
import SkeletonView

final class StoriesCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier = String(describing: StoriesCollectionCell.self)

    private let cornerRadius: CGFloat = 14
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10
    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10

    // MARK: - UI Properties
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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSkeleton()
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
        setupElementsLayout()
    }

    func setupElementsLayout() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset)
        ])
    }
}

// MARK: - Setup skeleton
private extension StoriesCollectionCell {
    func setupSkeleton() {
        isSkeletonable = true
    }
}
