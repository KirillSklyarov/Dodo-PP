import UIKit

enum CornerRadius: CGFloat {
    case ten = 10
    case fourTeen = 14
}

enum SubviewType {
    case image
    case label
}

// Класс, который просто рисует картинку вместо отсисовывания углов, тем самым уменьшает блендинг, из-за чего может тормозить скролл на коллекциях
final class DrawView: UIView {

    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        return label
    }()

    private var radius: CGFloat = 0

    // MARK: - Init
    init(cornerRadius: CornerRadius, subviewType: SubviewType = .label) {
        super.init(frame: .zero)
        self.radius = cornerRadius.rawValue
        setupView(with: subviewType)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(with: .image)
    }

    // MARK: - Public methods
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    func setLabelText(_ text: String) {
        label.text = text
    }

    // MARK: - Private methods
    private func setupView(with subviewType: SubviewType) {
        switch subviewType {
        case .image:
            addSubviews(imageView)
            imageView.setConstraints()
        case .label:
            addSubviews(label)
            label.setConstraints()
        }
    }
}

// MARK: - override draw method
extension DrawView {
    override func draw(_ rect: CGRect) {
        let maskPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)

        // Создаем маску для всего view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
