//
//  MovieController.swift
//  TheMovieDB
//
//  Created by Backup Admin on 4/19/22.
//

import Foundation

class MovieController {
    
    static let shared = MovieController()
    
    let baseURL = URL(string: "https://api.themoviedb.org/")!
    let API_KEY = "39d9c0eb21560fd9fc8088ed95b0ce30"
    
    enum MovieControllerError: Error, LocalizedError {
        case moviesNotFound
    }
    
    func fetchMovies() async throws -> [Movie] {
        let baseMoviesURL = baseURL.appendingPathComponent("3/movie/popular")
        
        var components = URLComponents(url: baseMoviesURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "api_key", value: API_KEY)]
        
        let moviesURL = components.url!
        let (data, response) = try await URLSession.shared.data(from: moviesURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw MovieControllerError.moviesNotFound
        }
        
        let decoder = JSONDecoder()
        let movieResponse = try decoder.decode(MoviesResponse.self, from: data)
        
        return movieResponse.results
    }
}
