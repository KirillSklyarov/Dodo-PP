import UIKit
import AppUIComponentsSPM

final class AppStartViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var dLabel: UILabel = {
        let label = UILabel()
        label.text = "D"
        label.textColor = AppColors.buttonOrange
        label.font = AppFonts.bold(size: 270).font
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    private var gradientLayer = CAGradientLayer()

    var onStartAppScreenFinished: (() -> Void)?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = dLabel.bounds
    }
}

// MARK: - Setup UI
private extension AppStartViewController {
    func setupUI() {
        view.backgroundColor = AppColors.backgroundGray
        view.addSubviews(dLabel)
        setupLayout()

        setupGradient()
        appearingAnimation()
    }

    func setupLayout() {
        dLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    // Настраиваем градиент
    func setupGradient() {
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]

        gradientLayer.locations = [0.0, 0.5, 1.0]

        dLabel.layer.mask = gradientLayer
    }

    // Делаем плавное появление лейбла
    func appearingAnimation() {
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { self.dLabel.alpha = 1 },
                       completion: { [weak self] _ in
                                    self?.startAppScreenFinished() }
        )
    }
}

// MARK: - Supporting methods
private extension AppStartViewController {
    func startAppScreenFinished() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.onStartAppScreenFinished?() }
    }
}
