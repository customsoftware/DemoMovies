//
//  DataEngine.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import Foundation
import UIKit
import Combine


class DataEngine {
    static let shared = DataEngine()
    
    private var cancellable = Set<AnyCancellable>()
    private(set) var defaultImage: UIImage = UIImage(named: "default")!
    
    /// In a production app, this key would not be stored in the app as it is here, but fetched via a secure call to a company authentication server so the key is protected
    private(set) var apiKey = "7bfe007798875393b05c5aa1ba26323e"
    private let fetchMovieListQuery: String = "https://api.themoviedb.org/3/movie/now_playing?api_key="
    
    func fetchMovieList() -> Future<MovieList, MovieError> {
        let queryString = buildQueryString()
        
        return Future { promise in
            guard let url = URL(string: queryString) else {
                return promise(.failure(.badURL(description: "Invalid URL String")))
            }
            
            
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
    
    func fetchMoviePoster(movieID: Int, imagePath: String) throws {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer 7bfe007798875393b05c5aa1ba26323e"
        ]
        
//        let headers = [
//          "accept": "application/json",
//          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiODM1OWE0OGU4NjVjNmRmZjE1ZGJjOGEzOGM2MGJkMSIsInN1YiI6IjYxYTdkMjViMzg0NjlhMDA5NmNlNDMyOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7xqG895daYN-tuIuMU0WNSG5smXQIOt-k52OCFw3_-k"
//        ]
        
        let movieArtURLString = buildPosterQuery(movieID, with: imagePath)
        guard let movieArtURL = URL(string: movieArtURLString) else { throw MovieError.badURL(description: "Invalid URL") }
        
        let request = NSMutableURLRequest(url: movieArtURL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        var networkError: MovieError = MovieError.noError
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let anError = error {
                networkError = MovieError.networkError(description: anError.localizedDescription)
            } else {
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode >= 200,
                      httpResponse.statusCode < 300,
                      let imageData = data else {
                    
                    networkError = MovieError.networkError(description: "Invalid Authentication")
                    return }
                
                self.defaultImage = UIImage(data: imageData)!
                
            }
            print(networkError.localizedDescription)
        })
        
        dataTask.resume()
    }
    
    func saveFavorites() {
        
    }
    
    func retrieveFavorites() {
        
    }
    
    private func buildPosterQuery(_ movieID: Int, with path: String) -> String {
        var retString = "https://api.themoviedb.org/3/"
//        var retString = "https://api.themoviedb.org/3/movie/movie_id/images"
//        retString = retString.replacingOccurrences(of: "movie_id", with: "\(movieID)")
        retString = retString.appending(path)
        return retString
    }
    
    private func buildQueryString() -> String {
        return "\(fetchMovieListQuery)\(apiKey)"
    }
}
