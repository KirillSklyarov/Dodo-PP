//
//  BlurView.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 02.10.2024.
//

import UIKit

final class CustomBlurView: UIVisualEffectView {

    private let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)

    override init(effect: UIVisualEffect?) {
        super.init(effect: blurEffect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
