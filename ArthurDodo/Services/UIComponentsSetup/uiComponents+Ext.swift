import UIKit
import AppUIComponentsSPM

extension AppLabel {
    func setPrice(_ item: Item) {
        let itemPrice = getPrice(item)
        self.text = itemPrice
    }

    func getPrice(_ item: Item) -> String {
        if let oneSize = item.itemSize.oneSize {
            return "\(oneSize.price) ₽"
        } else {
            let price = item.itemSize.medium?.price ?? 0
            return "от \(price) ₽"
        }
    }
}

// MARK: - Public methods
extension AppButtons {
    func setPrice(_ item: Item) {
        let itemPrice = getPrice(item)
        setTitle(itemPrice, for: .normal)
    }

    func setNewTitle(_ title: String) {
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold(size: 18).font])
        )
    }

    func setNewBackgroundColor(_ color: UIColor) {
        configuration?.background.backgroundColor = color
    }

    func updateCart(with totalPrice: Int) {
        setNewPrice(totalPrice)
        showOrHideCartButton(totalPrice)
    }

    func getPrice(_ item: Item) -> String {
        if let oneSize = item.itemSize.oneSize {
            return "\(oneSize.price) ₽"
        } else {
            let price = item.itemSize.medium?.price ?? 0
            return "от \(price) ₽"
        }
    }

    func showOrHideCartButton(_ totalPrice: Int) {
        isHidden = totalPrice > 0 ? false : true
    }

    func setNewPrice(_ price: Int) {
        let title = "\(price) ₽"
        configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .foregroundColor: UIColor.white,
            .font: AppFonts.bold(size: 18).font]))
    }
}

// MARK: - Public methods
extension AppCartButtonView {
    func updatePrice(_ price: Int) {
        currentPrice = price
        let title = if isCart {
            "Оформить заказ на \(price) ₽"
        } else {
            "В корзину за \(price) ₽"
        }
        cartButton?.setNewTitle(title)
    }

    func getCurrentPrice() -> Int {
        currentPrice
    }
}
