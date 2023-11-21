//
//  MovieDetailsView.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import SwiftUI

struct MovieDetailsView: View {
    @Binding var theMovie: Movie
    @State private var isFavorite: Bool = false
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            HStack {
                Text(theMovie.title)
            }
            
            HStack {
                Text("Description:")
            }
                
            HStack {
                Text(theMovie.overview)
                    .padding(.leading, 50)
            }
            Spacer()
        }
        .toolbar(content: {
            Button {
                if let isFav = theMovie.isFavorite {
                    isFavorite = !isFav
                } else {
                    isFavorite = true
                }
            } label: {
                HStack  {
                    if isFavorite {
                        Image(systemName: "heart.fill")
                    } else {
                        Image(systemName: "heart")
                    }
                }
            }.padding()
        })
        .onAppear(perform: {
            do {
                try DataEngine.shared.fetchMoviePoster(movieID: theMovie.id)
                isFavorite = theMovie.isFavoriteMovie()
            } catch let error {
                print("\(error.localizedDescription)")
            }
        })
        .onDisappear(perform: {
            
        })
        .padding()
    }
}

#Preview {
    MovieDetailsView(theMovie: .constant(Movie(adult: false, backdrop_path: "Try This", genre_ids: [1,2], id: 12345, original_language: "en", original_title: "Something", overview: "It was a movie", popularity: 23000, poster_path: "Some path", release_date: "23-11-2023", title: "Something", video: false, vote_average: 8.4, vote_count: 400)))
}
