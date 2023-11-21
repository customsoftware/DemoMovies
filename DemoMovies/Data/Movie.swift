//
//  Movie.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import Foundation

struct Movie: Codable, Identifiable, Comparable {
    static func <(lhs: Movie, rhs: Movie) -> Bool {
         return lhs.title < rhs.title
     }
    
    var adult: Bool
    var backdrop_path: String
    var genre_ids: [Int]
    var id: Int
    var original_language: String
    var original_title: String
    var overview: String
    var popularity: Double
    var poster_path: String
    var release_date: String
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int
    var isFavorite: Bool? = false
    
    
    // The way favorites are recorded, the value is NOT persistent between sessions.
    //  Exit the app and the favorite status goes away. To make it persist between sessions,
    //  the movie ID and favorite status can be stored to a dictionary and archived.
    //  Then when the data is fetched, the archive can be read and applied to the movie list
    func isFavoriteMovie() -> Bool {
        guard let isFave = isFavorite else { return false }
        return isFave
    }
}


struct DateRange: Codable {
    var maximum: String
    var minimum: String
}


struct MovieList: Codable {
    var dates: DateRange
    var page: Int
    var results: [Movie]
}


