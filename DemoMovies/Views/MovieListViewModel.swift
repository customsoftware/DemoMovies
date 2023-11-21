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
    
    var sortMode: MovieSort = .titleAlpha {
        didSet {
            preSortData(sortMode)
        }
    }
    @Published var showFavorites: Bool = false {
        didSet {
            if showFavorites {
                displayedMovies = displayedMovies.filter({ aMovie in
                    aMovie.isFavorite == true
                })
            } else {
                // Update found
                displayedMovies.forEach { aMovie in
                    updateMovieFaveStatus(aMovie, new: aMovie.isFavoriteMovie())
                }
                displayedMovies = foundMovies
                preSortData(sortMode)
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
                self?.preSortData(self?.sortMode ?? .titleAlpha)
            }
            .store(in: &cancellable)
    }
    
    
    func updateFaveStatusOfAllMovies() {
        // Reset them all, because some in displayed may have been altered
        foundMovies.forEach { aMovie in
            updateMovieFaveStatus(aMovie, new: false)
        }
        // Now update from displayed list
        displayedMovies.forEach { aMovie in
            updateMovieFaveStatus(aMovie, new: aMovie.isFavoriteMovie())
        }
    }
    
    
    private func preSortData(_ mode: MovieSort) {
        switch mode {
        case .titleAlpha:
            displayedMovies.sort()
        case .rating:
            displayedMovies.sort { m1, m2 in
                m1.vote_average > m2.vote_average
            }
        case .releaseDate:
            displayedMovies.sort { m1, m2 in
                m1.release_date > m2.release_date
            }
        }
    }
    
    private func updateMovieFaveStatus(_ movie: Movie, new faveStatus: Bool) {
        let foundIndex = foundMovies.firstIndex { aMovie in
            aMovie.id == movie.id
        }
        guard let anIndex = foundIndex else { return }
        foundMovies[anIndex].isFavorite = faveStatus
    }
}
