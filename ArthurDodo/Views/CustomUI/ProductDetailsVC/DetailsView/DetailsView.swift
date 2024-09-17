//
//  DetailsView.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

final class DetailsView: UIView {

    // MARK: - Size Properties
    private let pizzaImageSize: CGFloat = 350
    private let viewHeight: CGFloat = 580

    var onSegmentValueChanged: ( (Int) -> Void )?
    private var chosenSize: Size = .medium
    private var chosenDough: Dough = .basic

    // MARK: - UI Properties
    private lazy var pizzaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pizza")
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: pizzaImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: pizzaImageSize).isActive = true
        return imageView
    }()

    private lazy var sizeSegmentControl = CustomSegmentControl(items: ["25 cм", "30 см", "35 см"])

    private lazy var doughSegmentControl = CustomSegmentControl(items: ["Обычное", "Тонкое"])

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

    // MARK: - Public methods
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

    // MARK: - Private methods
    private func setupUI() {
        heightAnchor.constraint(equalToConstant: viewHeight).isActive = true

        backgroundColor = .systemYellow
        layer.cornerRadius = 20
        layer.masksToBounds = true

        addSubviews(pizzaImageView, sizeSegmentControl, doughSegmentControl)

        setupLayout()
    }

    private func setupLayout() {
        setupPizzaImageViewConstraints()
        setupSizeSegmentControlConstraints()
        setupDoughSegmentControlConstraints()
    }

    private func setupPizzaImageViewConstraints() {
        NSLayoutConstraint.activate([
            pizzaImageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            pizzaImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupSizeSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            sizeSegmentControl.topAnchor.constraint(equalTo: pizzaImageView.bottomAnchor, constant: 10),
            sizeSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            sizeSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    private func setupDoughSegmentControlConstraints() {
        NSLayoutConstraint.activate([
            doughSegmentControl.topAnchor.constraint(equalTo: sizeSegmentControl.bottomAnchor, constant: 5),
            doughSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            doughSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func setupSizeSegmentControl() {
        sizeSegmentControl.selectedSegmentIndex = 1
        sizeSegmentControl.onSegmentControllerValueChanged = { [weak self] index in
            self?.onSegmentValueChanged?(index)

            switch index {
            case 0: self?.chosenSize = .small
            case 1: self?.chosenSize = .medium
            case 2: self?.chosenSize = .large
            default: break }
        }
    }

    private func setupDoughSegmentControl() {
        doughSegmentControl.onSegmentControllerValueChanged = { [weak self] index in
            switch index {
            case 0: self?.chosenDough = .basic
            case 1: self?.chosenDough = .thin
            default: break
            }
        }
    }
}
