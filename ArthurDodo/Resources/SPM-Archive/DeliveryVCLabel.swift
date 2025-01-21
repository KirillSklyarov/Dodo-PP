//import UIKit
//import AppUIComponentsSPM
//
//enum DeliveryVCType {
//    case deliveryAddress
//    case deliveryTime
//    case paymentMethod
//}
//
//final class DeliveryVCLabel: UILabel {
//
//    init(frame: CGRect = .zero, type: DeliveryVCType) {
//        super.init(frame: frame)
//        setupUI(type)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: - Setup UI
//private extension DeliveryVCLabel {
//    func setupUI(_ type: DeliveryVCType) {
//        font = AppFonts.semibold(size: 20).font
//        textColor = .white
//        setText(type)
//    }
//
//    func setText(_ type: DeliveryVCType) {
//        self.text = switch type {
//        case .deliveryAddress: "Адрес доставки"
//        case .deliveryTime: "Время доставки"
//        case .paymentMethod: "Оплата"
//        }
//    }
//}
