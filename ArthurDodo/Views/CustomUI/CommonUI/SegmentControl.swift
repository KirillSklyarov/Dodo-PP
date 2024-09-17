//
//  SegmentControll.swift
//  ArthutDodo
//
//  Created by Kirill Sklyarov on 21.09.2024.
//

import UIKit

final class CustomSegmentControl: UISegmentedControl {

    var onSegmentControllerValueChanged: ((Int) -> Void)?

    override init(items: [Any]?) {
        super.init(items: items)
        configSegmentControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configSegmentControl() {
        setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .normal)
        selectedSegmentIndex = 0
        heightAnchor.constraint(equalToConstant: 40).isActive = true

        addTarget(self, action: #selector(sizeSegmentControlValueChanged), for: .valueChanged)
    }

    @objc private func sizeSegmentControlValueChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        onSegmentControllerValueChanged?(index)
    }
}
