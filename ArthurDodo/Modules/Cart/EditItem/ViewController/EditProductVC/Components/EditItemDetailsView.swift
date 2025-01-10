import UIKit

// Вью с картинкой и сегмент контроллерами на экране редактирования товара
final class EditItemDetailsView: UIView {

    // MARK: - UI Properties
    private lazy var itemImageView = AppImageView(type: .justView)
    private lazy var sizeSegmentControl = AppSegmentControl(type: .size)
    private lazy var doughSegmentControl = AppSegmentControl(type: .dough)
    private lazy var contentStackView = setupContentStackView()

    // MARK: - Size Properties
    private let pizzaImageSize: CGFloat = 340
    private let blurHeaderHeight: CGFloat = 70
    private let cornerRadius: CGFloat = 20

    private var chosenSize: Size?
    private var chosenDough: Dough?

    var onSizeValueChanged: ( (Size?) -> Void )?
    var onDoughValueChanged: ( (Dough?) -> Void )?

    // MARK: - Init
    init(frame: CGRect = .zero, chosenSize: Size? = nil, chosenDough: Dough? = nil) {
        super.init(frame: frame)
        self.chosenSize = chosenSize
        self.chosenDough = chosenDough
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setChosenSizeAndDough(_ size: Size, _ dough: Dough) {
        self.chosenSize = size
        self.chosenDough = dough
        sizeSegmentControl.setDefaultSelectedSegment(chosenSize!.rawValue)
        doughSegmentControl.setDefaultSelectedSegment(chosenDough!.rawValue)
    }
}

// MARK: - Public methods
extension EditItemDetailsView {
    func hideDoughSegment() {
        doughSegmentControl.isHidden = true
    }

    func hideSizeSegment() {
        sizeSegmentControl.isHidden = true
    }

    func updatePizzaImage(_ imageName: String) {
        let image = UIImage(named: imageName)
        itemImageView.image = image
    }

    func getChosenSize() -> Size? {
        chosenSize
    }

    func getChosenDough() -> Dough? {
        chosenDough
    }
}

// MARK: - Setup UI
private extension EditItemDetailsView {
    func setupUI() {
        backgroundColor = AppColorsEnum.productBackground.color
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        contentStackView.setLocalConstraints(bottom: 20, left: 20, right: 20)
        contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: blurHeaderHeight).isActive = true
        
        itemImageView.heightAnchor.constraint(equalToConstant: pizzaImageSize).isActive = true
    }
}

// MARK: - Setup actions
private extension EditItemDetailsView {
    func setupAction() {
        setupSizeSegmentControl()
        setupDoughSegmentControl()
    }

    func setupSizeSegmentControl() {
        sizeSegmentControl.onSegmentValueChanged = { [weak self] index in
            guard let self else { print("123"); return }
            switch index {
            case 0: chosenSize = .small
            case 1: chosenSize = .medium
            case 2: chosenSize = .large
            default: break }
            onSizeValueChanged?(chosenSize)
        }
    }

    private func setupDoughSegmentControl() {
        doughSegmentControl.onSegmentValueChanged = { [weak self] index in
            guard let self else { print("123"); return }
            switch index {
            case 0: chosenDough = .basic
            case 1: chosenDough = .thin
            default: break
            }
            onDoughValueChanged?(chosenDough)
        }
    }
}

// MARK: - Supporting methods
private extension EditItemDetailsView {
    func setupContentStackView() -> UIStackView {
        let  segmentsControlStackView = AppStackView([sizeSegmentControl, doughSegmentControl], axis: .vertical, spacing: 5)
        let  contentStackView = AppStackView([itemImageView, segmentsControlStackView], axis: .vertical, spacing: 10)
        return contentStackView
    }
}


    // Если сегменты скрыты, то помещаем картинку в центре
//     func placeImageInCenter() {
//        imageCenterY?.isActive = false
//        imageCenterY = pizzaImageView.topAnchor.constraint(equalTo: topAnchor)
//
//        if doughSegmentControl.isHidden && sizeSegmentControl.isHidden {
//            let topPadding = viewHeight - blurHeaderHeight - pizzaImageSize
//            imageCenterY?.constant = blurHeaderHeight + topPadding / 2
//        } else {
//            imageCenterY?.constant = 120
//        }
//        imageCenterY?.isActive = true
//    }
//}


//    func turningOffUserInteractionSegments() {
//        sizeSegmentControl.isUserInteractionEnabled = false
//        doughSegmentControl.isUserInteractionEnabled = false
//    }

//    func turningOnUserInteractionSegments() {
//        sizeSegmentControl.isUserInteractionEnabled = true
//        doughSegmentControl.isUserInteractionEnabled = true
//    }
