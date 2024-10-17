//
//  ChatAlertController.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 11.10.2024.
//

import UIKit

final class AlertHelper {

    static func showChatAlert(in vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Позвонить", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Написать в чат", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

        vc.present(alert, animated: true)
    }
}
