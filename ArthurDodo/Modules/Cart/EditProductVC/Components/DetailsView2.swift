import UIKit

final class DetailsView2: UIView {

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: pizzaImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: pizzaImageSize).isActive = true
        return imageView
    }()
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.addSubviews(pizzaImageView)
        return view
    }()
    private lazy var sizeSegmentControl = SegmentControlView(items: AppConstants.sizeCases, defaultSelection: 1)
    private lazy var doughSegmentControl = SegmentControlView(items: AppConstants.doughCases, defaultSelection: 0)
    private lazy var segmentsControlStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sizeSegmentControl, doughSegmentControl])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContainerView, segmentsControlStackView])
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Size Properties
    private let pizzaImageSize: CGFloat = 340
    private let blurHeaderHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 20

    private let topInset: CGFloat = 10
    private let bottomInset: CGFloat = -10
    private let leftInset: CGFloat = 10
    private let rightInset: CGFloat = -10

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
        setupSizeSegmentControl()
        setupDoughSegmentControl()
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//        setupSizeSegmentControl()
//        setupDoughSegmentControl()
//    }

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
extension DetailsView2 {
    func hideDoughSegment() {
        doughSegmentControl.isHidden = true
//        placeImageInCenter()
    }

    func hideSizeSegment() {
        sizeSegmentControl.isHidden = true
//        placeImageInCenter()
    }

    func updatePizzaImage(_ imageName: String) {
        let image = UIImage(named: imageName)
        pizzaImageView.image = image
    }

    func getChosenSize() -> Size? {
        chosenSize
    }

    func getChosenDough() -> Dough? {
        chosenDough
    }
}

// MARK: - Setup UI
private extension DetailsView2 {
    func setupUI() {
        backgroundColor = UIColor(hex: "485460")
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        addSubviews(contentStackView)

        setupLayout()
    }

    func setupLayout() {
        setupImageViewLayout()
        setupContentStackLayout()
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: blurHeaderHeight),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset*2),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightInset*2),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset)
        ])
    }

    func setupImageViewLayout() {
        NSLayoutConstraint.activate([
            pizzaImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: topInset),
            pizzaImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: bottomInset),
            pizzaImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor)
        ])
    }
}

// MARK: - Setup actions
private extension DetailsView2 {
    func setupAction() {
        setupSizeSegmentControl()
        setupDoughSegmentControl()
    }

    func setupSizeSegmentControl() {
        sizeSegmentControl.onSegmentControllerValueChanged = { [weak self] index in
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
        doughSegmentControl.onSegmentControllerValueChanged = { [weak self] index in
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
private extension DetailsView2 {
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
}


//    func turningOffUserInteractionSegments() {
//        sizeSegmentControl.isUserInteractionEnabled = false
//        doughSegmentControl.isUserInteractionEnabled = false
//    }

//    func turningOnUserInteractionSegments() {
//        sizeSegmentControl.isUserInteractionEnabled = true
//        doughSegmentControl.isUserInteractionEnabled = true
//    }
