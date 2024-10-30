//
//  UserDefaults+Ext.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 09.10.2024.
//

import Foundation

extension UserDefaults {

    enum Keys {
        static let preferredPaymentMethod = "preferredPaymentMethod"
        static let viewedStories = "viewedStories"
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
}

// MARK: - Preferred payment method
extension UserDefaults {
    func getPreferredPaymentMethod() -> String? {
        if let paymentMethodTitle = string(forKey: Keys.preferredPaymentMethod) {
            return paymentMethodTitle
        } else {
            print("No preferred payment method set")
            return nil
        }
    }
    
    func setPreferredPaymentMethod(_ paymentMethod: PaymentMethod) {
        set(paymentMethod.title, forKey: Keys.preferredPaymentMethod)
    }
}
