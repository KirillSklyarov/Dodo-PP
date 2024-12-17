//
//  StoriesModel.swift
//  ArthurDodo
//
//  Created by Kirill Sklyarov on 08.10.2024.
//

import Foundation

struct Story: Codable {
    let id: String
    let coverImage: String
    let description: String
    let subStories: [String]

    init(id: String, storyCoverImage: String, storyDescription: String, subStories: [String]) {
        self.id = id
        self.coverImage = storyCoverImage
        self.description = storyDescription
        self.subStories = subStories
    }
}
