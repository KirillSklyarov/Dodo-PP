import UIKit

// Вью с картинкой и сегментами на экране DetailsVC
final class DetailsView: UIView {

    // MARK: - UI Properties
    private lazy var itemImageView = AppImageView(type: .justView)
    private lazy var sizeSegmentControl = AppSegmentControl(type: .size)
    private lazy var doughSegmentControl = AppSegmentControl(type: .dough)

    private lazy var contentStack = AppStackView([itemImageView, sizeSegmentControl, doughSegmentControl], axis: .vertical, spacing: 10)

    // MARK: - Size Properties
    private let pizzaImageSize: CGFloat = 350
    private let viewHeight: CGFloat = 580
    private let blurHeaderHeight: CGFloat = 110

    private var chosenSize: Size = .medium
    private var chosenDough: Dough = .basic

    var imageCenterY: NSLayoutConstraint?

    var onSegmentValueChanged: ( (Int) -> Void )?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSizeSegmentControl()
        setupDoughSegmentControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension DetailsView {
    func hideDoughSegment() {
        doughSegmentControl.isHidden = true
//        placeImageInCenter()
    }

    func hideSizeSegment() {
        sizeSegmentControl.isHidden = true
//        placeImageInCenter()
    }

    // Если сегменты скрыты, то помещаем картинку в центре
    func placeImageInCenter() {
        imageCenterY?.isActive = false
        imageCenterY = itemImageView.topAnchor.constraint(equalTo: topAnchor)

        if doughSegmentControl.isHidden && sizeSegmentControl.isHidden {
            let topPadding = viewHeight - blurHeaderHeight - pizzaImageSize
            imageCenterY?.constant = blurHeaderHeight + topPadding / 2
        } else {
            imageCenterY?.constant = 120
        }
        imageCenterY?.isActive = true
    }

    func turningOffUserInteractionSegments() {
        sizeSegmentControl.isUserInteractionEnabled = false
        doughSegmentControl.isUserInteractionEnabled = false
    }

    func turningOnUserInteractionSegments() {
        sizeSegmentControl.isUserInteractionEnabled = true
        doughSegmentControl.isUserInteractionEnabled = true
    }

    func updatePizzaImage(_ imageName: String) {
        let image = UIImage(named: imageName)
        itemImageView.image = image
    }

    func getChosenSize() -> Size {
        chosenSize
    }

    func getChosenDough() -> Dough {
        chosenDough
    }
}

// MARK: - Setup UI
private extension DetailsView {
    func setupUI() {
        backgroundColor = AppColors.detailsBackground
        layer.cornerRadius = 20
        layer.masksToBounds = true

        addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        contentStack.setLocalConstraints(top: 120, bottom: 20, left: 20, right: 20)
        itemImageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    func setupSizeSegmentControl() {
        sizeSegmentControl.onSegmentValueChanged = { [weak self] index in
            guard let self else { print("123"); return }
            onSegmentValueChanged?(index)

            switch index {
            case 0: chosenSize = .small
            case 1: chosenSize = .medium
            case 2: chosenSize = .large
                default: break }
        }
    }

    func setupDoughSegmentControl() {
        doughSegmentControl.onSegmentValueChanged = { [weak self] index in
            guard let self else { print("123"); return }
            switch index {
            case 0: chosenDough = .basic
            case 1: chosenDough = .thin
            default: break
            }
        }
    }
}
