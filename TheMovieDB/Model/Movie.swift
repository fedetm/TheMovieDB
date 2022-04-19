//
//  Movie.swift
//  TheMovieDB
//
//  Created by Backup Admin on 4/18/22.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var detailText: String
    var imageURL: URL
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case detailText = "overview"
        case imageURL = "poster_path"
        case title
    }
}
