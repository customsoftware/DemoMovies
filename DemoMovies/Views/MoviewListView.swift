//
//  ContentView.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import SwiftUI
import Combine

struct MoviewListView: View {
    
    @ObservedObject var viewModel = MovieListViewModel(engine: DataEngine.shared)
    
    init() {
        viewModel.fetchMovies()
    }
    
    var body: some View {
        NavigationStack {
            List($viewModel.displayedMovies) { $aMovie in
                NavigationLink {
                    MovieDetailsView(theMovie: $aMovie)
                } label: {
                    MovieListItemView(theMovie: aMovie)
                }
            }
            .navigationTitle("Movie List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    viewModel.showFavorites = !viewModel.showFavorites
                },
                    label: {
                    if !viewModel.showFavorites {
                        Text("Show Faves")
                    } else {
                        Text("Show All")
                    }
                })
//                Button( action: { },
//                        label: {
//                    NavigationLink {
//                        SortView()
//                    } label: {
//                        Text("Sort")
//                    }
//                })
            })
        }

    }
}

#Preview {
    MoviewListView()
}


struct SortView: View {
    var body: some View {
        Text("Sort me")
    }
}
