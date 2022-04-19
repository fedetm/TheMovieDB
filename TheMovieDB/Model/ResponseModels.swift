//
//  ResponseModels.swift
//  TheMovieDB
//
//  Created by Backup Admin on 4/18/22.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}
