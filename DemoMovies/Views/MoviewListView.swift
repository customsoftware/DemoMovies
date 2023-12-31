//
//  ContentView.swift
//  DemoMovies
//
//  Created by Kenneth Cluff on 11/21/23.
//

import SwiftUI
import Combine

struct MoviewListView: View {
    @State private var showingOptions = false
    @State private var searchText: String = ""
    @ObservedObject var viewModel = MovieListViewModel(engine: DataEngine.shared)
    
    init() {
        viewModel.fetchMovies()
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.displayedMovies.count == 0 {
                Text("No favorites selected")
                    .toolbar(content: {
                        Button(action: {
                            viewModel.showFavorites = false
                        },
                        label: {
                            Text("Show All")
                        })
                    })
            } else {
                List($viewModel.displayedMovies) { $aMovie in
                    NavigationLink {
                        MovieDetailsView(theMovie: $aMovie)
                    } label: {
                        MovieListItemView(theMovie: aMovie)
                    }
                }
                .navigationTitle("Movie List")
                .navigationBarTitleDisplayMode(.automatic)
                .onAppear(perform: {
                    viewModel.updateFaveStatusOfAllMovies()
                })
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
                    
                    Button("Sort") {
                        showingOptions = true
                    }
                    .actionSheet(isPresented: $showingOptions) {
                        ActionSheet(
                            title: Text("Select a Sort Option"),
                            buttons: [
                                .default(Text(MovieSort.titleAlpha.text)) {
                                    viewModel.sortMode = MovieSort.titleAlpha
                                },
                                
                                .default(Text(MovieSort.releaseDate.text)) {
                                    viewModel.sortMode = MovieSort.releaseDate
                                },
                            
                                .default(Text(MovieSort.rating.text)) {
                                    viewModel.sortMode = MovieSort.rating
                                },
                        
                                .cancel()
                            ]
                        )
                    }
                })
                Spacer()
            }
 
        }
    }
}

#Preview {
    MoviewListView()
}
