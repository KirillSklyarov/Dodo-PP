import Foundation

extension UserDefaults {
    enum Keys {
        static let preferredPaymentMethod = "preferredPaymentMethod"
        static let viewedStories = "viewedStories"
        static let order = "order"
    }
}

// MARK: - Stories
extension UserDefaults {
    func getArrayOfViewedStories() -> [String] {
        return self.stringArray(forKey: Keys.viewedStories) ?? []
    }

    func markStoryAsViewed(_ storyID: String) {
        var viewedStories = self.getArrayOfViewedStories()
        if !viewedStories.contains(storyID) {
            viewedStories.append(storyID)
            self.set(viewedStories, forKey: Keys.viewedStories)
        }
    }

    func isStoryViewed(_ storyID: String) -> Bool {
        let viewedStories = self.getArrayOfViewedStories()
        return viewedStories.contains(storyID)
    }

    // Сброс просмотренных историй (для отладки)
    func resetViewedStories() {
        self.set([], forKey: Keys.viewedStories)
    }
}

// MARK: - Preferred payment method
extension UserDefaults {
    func getPreferredPaymentMethod() -> String? {
        if let paymentMethodTitle = string(forKey: Keys.preferredPaymentMethod) {
            return paymentMethodTitle
        } else {
//            print("No preferred payment method set")
            return nil
        }
    }

    func setPreferredPaymentMethod(_ paymentMethod: PaymentMethod) {
        set(paymentMethod.title, forKey: Keys.preferredPaymentMethod)
    }
}

// MARK: - Active order
extension UserDefaults {
//    func setActiveOrderIsTrue() {
//        set(true, forKey: Keys.isActiveOrder)
//    }
//
    func getIsActiveOrder() -> Bool {
        return data(forKey: Keys.order) != nil
    }

    func resetActiveOrder() {
        removeObject(forKey: Keys.order)
        print("Active order reset")
    }

    func sendOrder(_ order: Order) {
        if let encodedOrder = try? JSONEncoder().encode(order) {
            set(encodedOrder, forKey: Keys.order)
        } else {
            print("We couldn't encode the order to UserDefaults.")
        }
    }

    func getOrder() -> Order? {
        guard let encodedOrder = data(forKey: Keys.order) else { return nil }
        guard let order = try? JSONDecoder().decode(Order.self, from: encodedOrder) else { print("We couldn't decode the order from UserDefaults."); return nil }
        return order
    }
}


