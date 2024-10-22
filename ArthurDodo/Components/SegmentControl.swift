//
//  SegmentControll.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

// Здесь делается фон и на него накладывается сегментКонтрол
final class SegmentControlView: UIView {

    // MARK: - Properties&Callbacks
    private let viewHeight: CGFloat = 40
    private var segmentControl: CustomSegmentControl?

    var onSegmentControllerValueChanged: ((Int) -> Void)?

    // MARK: - Init
    init(frame: CGRect = .zero, items: [Any]?, defaultSelection: Int) {
        super.init(frame: frame)
        segmentControl = CustomSegmentControl(items: items, defaultSelection: defaultSelection)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSegmentColor(_ color: UIColor) {
        segmentControl?.setSegmentColor(color)
    }
}

// MARK: - Setup UI
private extension SegmentControlView {
     func setupUI() {
        backgroundColor = AppColors.backgroundGray
        layer.cornerRadius = viewHeight / 2
        clipsToBounds = true

        guard let segmentControl else { return }
        addSubviews(segmentControl)

        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -2),
            segmentControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),

            heightAnchor.constraint(equalToConstant: viewHeight)
        ])
    }
}

// MARK: - Setup Actions
private extension SegmentControlView {
     func setupActions() {
        segmentControl?.onSegmentControllerValueChanged = { [weak self] index in
            self?.onSegmentControllerValueChanged?(index)
        }
    }
}
