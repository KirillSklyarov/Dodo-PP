//
//  UserDefaults+Ext.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 09.10.2024.
//

import Foundation

extension UserDefaults {
    static private let viewedStories = "viewedStories"

    func getArrayOfViewedStories() -> [String] {
        return self.stringArray(forKey: Self.viewedStories) ?? []
    }

    func markStoryAsViewed(_ storyID: String) {
        var viewedStories = self.getArrayOfViewedStories()
        if !viewedStories.contains(storyID) {
            viewedStories.append(storyID)
            self.set(viewedStories, forKey: Self.viewedStories)
        }
    }

    func isStoryViewed(_ storyID: String) -> Bool {
        let viewedStories = self.getArrayOfViewedStories()
        return viewedStories.contains(storyID)
    }
}
