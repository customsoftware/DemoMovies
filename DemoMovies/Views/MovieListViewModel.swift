//
//  MovieListViewModel.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import Foundation
import Combine


@MainActor class MovieListViewModel: ObservableObject {
    private var foundMovies: [Movie]
    @Published var showFavorites: Bool = false {
        didSet {
            if showFavorites {
                displayedMovies = foundMovies.filter({ aMovie in
                    aMovie.isFavorite == true
                })
            } else {
                displayedMovies = foundMovies
            }
        }
    }
    @Published private(set) var errorText: String?
    @Published var displayedMovies: [Movie]
    
    let engine: DataEngine
    private var cancellable = Set<AnyCancellable>()
    
    init(engine: DataEngine) {
        self.engine = engine
        self.foundMovies = []
        self.displayedMovies = []
    }
    
    func fetchMovies() {
        engine.fetchMovieList()
            .sink { [weak self] completion in
                switch completion  {
                case .finished:
                    print("Finished getting the movies")
                case .failure(let error):
                    let title: String
                    switch error {
                    case .badURL(description: _):
                        title = "Bad URL"
                    case .networkError(description: _):
                        title = "Network error"
                    case .parsingError(description: _):
                        title = "Parsing Error"
                    case .noError:
                        title = "No Error"
                    }
                    
                    self?.errorText = "There was a \(title) with this information: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] movies in
                self?.foundMovies = movies.results
                self?.displayedMovies = movies.results
            }
            .store(in: &cancellable)
    }
    
    
    func updateMovieFaveStatus(_ movie: Movie, new faveStatus: Bool) {
        let foundIndex = foundMovies.firstIndex { aMovie in
            aMovie.id == movie.id
        }
        guard let anIndex = foundIndex else { return }
        foundMovies[anIndex].isFavorite = faveStatus
    }
}
