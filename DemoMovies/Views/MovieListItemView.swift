//
//  MovieListItemView.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import SwiftUI

struct MovieListItemView: View {
    @State var theMovie: Movie
    
    var body: some View {
        HStack {
            Button {                
            } label: {
                if theMovie.isFavorite ?? false {
                    Image(systemName: "heart.fill")
                } else {
                    Image(systemName: "heart")
                }
            }
            Text("\(theMovie.title)")
        }
    }
}

#Preview {
    MovieListItemView(theMovie: Movie(adult: false, backdrop_path: "Try This", genre_ids: [1,2], id: 12345, original_language: "en", original_title: "Something", overview: "It was a movie", popularity: 23000, poster_path: "Some path", release_date: "23-11-2023", title: "Something", video: false, vote_average: 8.4, vote_count: 400))
}
