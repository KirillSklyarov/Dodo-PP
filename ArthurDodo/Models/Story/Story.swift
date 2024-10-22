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
    let subStoryImages: [String]

    init(id: String, storyCoverImage: String, storyDescription: String, subStoryImages: [String]) {
        self.id = id
        self.coverImage = storyCoverImage
        self.description = storyDescription
        self.subStoryImages = subStoryImages
    }
}
