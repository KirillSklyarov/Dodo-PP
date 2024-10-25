import UIKit

final class AddToCartCollectionCell: UICollectionViewCell {

    // MARK: - Properties
    static let identifier: String = "AddToCartCollectionCell"
    private let imageSize: CGFloat = 100
    private let priceLabelHeight: CGFloat = 25
    private let cornerRadius: CGFloat = 10
    private let leftInset: CGFloat = 5
    private let rightInset: CGFloat = -5
    private let topInset: CGFloat = 5
    private let bottomInset: CGFloat = -5

    // MARK: - UI Properties
    private lazy var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.backgroundGray
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "pizza")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        return imageView
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.semibold12
        label.backgroundColor = AppColors.buttonGray
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = cornerRadius
        label.layer.masksToBounds = true
        label.heightAnchor.constraint(equalToConstant: priceLabelHeight).isActive = true
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.bold14
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular12
        label.numberOfLines = 0
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var detailsLabelContainer: UIView = {
        let view = UIView()
        view.addSubviews(detailsLabel)
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemImageView, titleLabel, detailsLabelContainer, priceLabel])
        stack.axis = .vertical
        stack.spacing = 5
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        detailsLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        return stack
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configCell(_ itemToAdd: Item) {
        itemImageView.image = UIImage(named: itemToAdd.imageName)
        titleLabel.text = itemToAdd.name
        setProductDetails(itemToAdd)
        setPrice(itemToAdd)
    }
}

// MARK: - Supporting methods
private extension AddToCartCollectionCell {
    func setProductDetails(_ item: Item) {
        let dough = item.getCorrectDough()
        let size = item.getCorrectSize().displayName
        let weight = item.getCorrectWeight()
        if let dough {
            detailsLabel.text = "\(size), \(dough)"
        } else {
            detailsLabel.text = "\(weight) г"
        }
    }

    func setPrice(_ item: Item) {
        let price = item.getCorrectPrice()
        let title = "\(price) ₽"
        priceLabel.text = title
    }
}

// MARK: - Setup UI
private extension AddToCartCollectionCell {
    func setupUI() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        contentView.addSubviews(cellBackgroundView, contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
        setupBackgroundViewLayout()
        setupDetailsContainerLayout()
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topInset),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leftInset),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: rightInset),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: bottomInset),
        ])
    }

    func setupBackgroundViewLayout() {
        NSLayoutConstraint.activate([
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.topAnchor.constraint(equalTo: itemImageView.centerYAnchor)
        ])
    }

    func setupDetailsContainerLayout() {
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: detailsLabelContainer.topAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: detailsLabelContainer.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: detailsLabelContainer.trailingAnchor),
            detailsLabel.bottomAnchor.constraint(lessThanOrEqualTo: detailsLabelContainer.bottomAnchor)
        ])
    }
}
