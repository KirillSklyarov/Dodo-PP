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

//let stories = [
//    StoriesModel(id: "B8C9D0E1-F2A3-4567-89AB-CDEF12345678", storyCoverImage: "story1", storyDescription: "История 1", subStoryImages: ["story1"]),
//    StoriesModel(id: "A7B8C9D0-E1F2-3456-789A-BCDEF1234567", storyCoverImage: "story2", storyDescription: "История 2", subStoryImages: ["story2"]),
//    StoriesModel(id: "F6A7B8C9-D0E1-2345-6789-ABCDEF123456", storyCoverImage: "story3", storyDescription: "История 3", subStoryImages: ["story3"]),
//    StoriesModel(id: "C9D0E1F2-A3B4-5678-9ABC-DEF123456789", storyCoverImage: "story4", storyDescription: "История 4", subStoryImages: ["story4","story1","story2"])
//]
