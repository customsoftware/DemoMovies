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
    @State private(set) var posterImage: UIImage = UIImage(named: "default")!
    
    var body: some View {
        VStack(alignment: .listRowSeparatorLeading) {
            Text(theMovie.title)
                .font(.title)
            Divider()
            Text("Description:")
                .bold()
            Text(theMovie.overview)
                .frame(minHeight: 100)
                .font(.caption)
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Rating: ")
                    Text(String(format: "%g",round(theMovie.vote_average * 100)/100))
                }
                VStack(alignment: .leading) {
                    Text("Release date:")
                    Text("\(theMovie.release_date)")
                }
            }
            AsyncImage(url: buildImageURL(theMovie.poster_path), scale: 1)
                .frame(width: 220, height: 330)
                .clipped()
                .fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: true)
                .padding()
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
            isFavorite = theMovie.isFavoriteMovie()
        })
        .onDisappear(perform: {
            theMovie.isFavorite = isFavorite
        })
        .padding()
        Spacer()
    }
    
    private func buildImageURL(_ endString: String) -> URL? {
        var retString = "https://image.tmdb.org/t/p/w220_and_h330_face"
        retString.append(endString)
        return URL(string: retString)
    }
    
}

#Preview {
    MovieDetailsView(theMovie: .constant(Movie(adult: false, backdrop_path: "Try This", genre_ids: [1,2], id: 12345, original_language: "en", original_title: "Something", overview: "It was a movie", popularity: 23000, poster_path: "Some path", release_date: "23-11-2023", title: "Something", video: false, vote_average: 8.4, vote_count: 400)))
}
