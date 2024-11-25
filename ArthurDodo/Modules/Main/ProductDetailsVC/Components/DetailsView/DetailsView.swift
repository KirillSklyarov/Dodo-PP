import UIKit

final class DetailsView: UIView {

    // MARK: - UI Properties
    private lazy var pizzaImageView = AppImageView(squareSize: pizzaImageSize)
    private lazy var sizeSegmentControl = SegmentControlView(items: AppConstants.sizeCases, defaultSelection: 1)
    private lazy var doughSegmentControl = SegmentControlView(items: AppConstants.doughCases, defaultSelection: 0)

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
        placeImageInCenter()
    }

    func hideSizeSegment() {
        sizeSegmentControl.isHidden = true
        placeImageInCenter()
    }

    // Если сегменты скрыты, то помещаем картинку в центре
    func placeImageInCenter() {
        imageCenterY?.isActive = false
        imageCenterY = pizzaImageView.topAnchor.constraint(equalTo: topAnchor)

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
        pizzaImageView.image = image
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
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        backgroundColor = UIColor(hex: "485460")
        layer.cornerRadius = 20
        layer.masksToBounds = true

        addSubviews(pizzaImageView, sizeSegmentControl, doughSegmentControl)

        setupLayout()
    }

    func setupLayout() {
        setupPizzaImageViewConstraints()
        setupSizeSegmentControlConstraints()
        setupDoughSegmentControlConstraints()
    }

    func setupPizzaImageViewConstraints() {
        placeImageInCenter()
        NSLayoutConstraint.activate([
            pizzaImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    func setupSizeSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            sizeSegmentControl.topAnchor.constraint(equalTo: pizzaImageView.bottomAnchor, constant: 10),
            sizeSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sizeSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    func setupDoughSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            doughSegmentControl.topAnchor.constraint(equalTo: sizeSegmentControl.bottomAnchor, constant: 5),
            doughSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doughSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    func setupSizeSegmentControl() {
        sizeSegmentControl.onSegmentControllerValueChanged = { [weak self] index in
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
        doughSegmentControl.onSegmentControllerValueChanged = { [weak self] index in
            guard let self else { print("123"); return }
            switch index {
            case 0: chosenDough = .basic
            case 1: chosenDough = .thin
            default: break
            }
        }
    }
}
