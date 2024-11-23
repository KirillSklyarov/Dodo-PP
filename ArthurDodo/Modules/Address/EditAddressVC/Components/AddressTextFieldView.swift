import UIKit

final class AddressTextFieldView: UIView {

    // MARK: - UI Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.grayFont
        label.font = AppFonts.regular12
        return label
    }()
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.tintColor = AppColors.grayFont
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        let placeholder = "123"
        textField.textColor = .white
        textField.font = AppFonts.semibold14
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: AppColors.grayFont])
        return textField
    }()
    private lazy var textStack = AppStackView([titleLabel, textField], axis: .vertical, spacing: 0)

    private lazy var contentStack = AppStackView([textStack, clearButton], axis: .horizontal)

    // MARK: - Properties
    private let leftPadding: CGFloat = 10
    private let rightPadding: CGFloat = -5
    private let topPadding: CGFloat = 5
    private let bottomPadding: CGFloat = -5

    private let viewHeight: CGFloat = 50

    var onTextFieldEndEditing: ((String) -> Void)?

    // MARK: - Init
    init(_ title: AddressTextFieldType) {
        super.init(frame: .zero)
        textField.delegate = self
        titleLabel.text = title.rawValue
        titleLabel.isHidden = true
        textField.placeholder = title.rawValue
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureView(_ textFieldText: String?) {
        if let text = textFieldText, !text.isEmpty  {
            titleLabel.isHidden = false
            textField.text = textFieldText
        } else {
            titleLabel.isHidden = true
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [.foregroundColor: AppColors.grayFont])
        }
    }
}

// MARK: - Setup UI
private extension AddressTextFieldView {
    func setupUI() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setBorder(AppColors.grayFont, borderWidth: 0.7)
        addSubviews(contentStack)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftPadding),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightPadding),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding),

            clearButton.widthAnchor.constraint(equalTo: contentStack.heightAnchor),
            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension AddressTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTextFieldEditing(textField, isEditing: true) // Показываем правильный дизайн для режима редактирования
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        isTextFieldEditing(textField, isEditing: false) // Показываем правильный дизайн для режима НЕредактирования
        guard let text = textField.text else { print("Warning: textField.text is nil"); return }
        onTextFieldEndEditing?(text)
    }
}

// MARK: - Supporting methods
private extension AddressTextFieldView {
    @objc func clearButtonTapped() {
        textField.text = nil
    }

    func isTextFieldEditing(_ textField: UITextField, isEditing: Bool) {
        switch isEditing {
        case true:
            clearButton.isHidden = false // Показываем clearButton
            titleLabel.isHidden = false // Показываем title
            textField.placeholder = nil // Убираем placeholder у тексфилда
        case false:
            guard let text = textField.text else { print("Warning: textField.text is nil"); return }
            clearButton.isHidden = text.isEmpty // Прячем clearButton
            titleLabel.isHidden = true // Прячем titleLabel
            textField.placeholder = titleLabel.text // Показываем placeholder у тексфилда
        }
    }
}
