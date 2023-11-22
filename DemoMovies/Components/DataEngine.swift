//
//  DataEngine.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import Foundation
import UIKit
import Combine


class DataEngine: ObservableObject {
    static let shared = DataEngine()
    
    private var cancellable = Set<AnyCancellable>()
    @Published private(set) var defaultImage: UIImage = UIImage(named: "default")!
    
    // In a production app, this key would not be stored in the app as it is here,
    //  but fetched via a secure call to a company authentication server so the key is protected
    private(set) var apiKey = "7bfe007798875393b05c5aa1ba26323e"
    private let fetchMovieListQuery: String = "https://api.themoviedb.org/3/movie/now_playing?api_key="
    
    
    /// This is where the movie list is fetched
    /// - Parameters:
    /// - None
    /// This uses Combine to asynchronously fetch the data from the server
    func fetchMovieList() -> Future<MovieList, MovieError> {
        let queryString = buildQueryString()
        
        return Future { promise in
            guard let url = URL(string: queryString) else {
                return promise(.failure(.badURL(description: "Invalid URL String")))
            }
            
            // Here is where the work gets done
            URLSession.shared.dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap {(data, response) in
                    guard let aResponse = response as? HTTPURLResponse,
                          aResponse.statusCode >= 200,
                          aResponse.statusCode < 300 else {
                        if let aResponse = response as? HTTPURLResponse {
                            throw MovieError.networkError(description: "Invalid status code: \(aResponse.statusCode)")
                        } else {
                            throw MovieError.networkError(description: "Invalid response")
                        }
                    }
                    return data
                }
                .decode(type: MovieList.self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:()
                    case .failure(let error):
                        if let decError = error as? MovieError {
                            return promise(.failure(decError))
                        } else {
                            return promise(.failure(.parsingError(description: "\(error.localizedDescription)")))
                        }
                    }
                    
                } receiveValue: { values in
                    return promise(.success(values))
                }
                .store(in: &self.cancellable)
        }
    }
    
    func saveFavorites() {
        
    }
    
    func retrieveFavorites() {
        
    }
    
    private func buildQueryString() -> String {
        return "\(fetchMovieListQuery)\(apiKey)"
    }
}
