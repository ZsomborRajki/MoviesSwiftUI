//
//  MoviesSearchView.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import SwiftUI

struct MoviesSearchView: View {
    @ObservedObject var viewModel: MoviesSearchViewModel
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar
                content
                Spacer()
            }
            .navigationBarTitle("Search")
            
        }
        .onAppear {
            UIApplication.shared.addTapGestureRecognizer()
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ActivityIndicator(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let movies):
            return list(of: movies)
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.hideKeyboard()
                })
                .eraseToAnyView()
        }
    }
    
    private func list(of movies: [MoviesSearchViewModel.ListItem]) -> some View {
        return List(movies) { movie in
            NavigationLink(
                destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id)),
                label: { MovieSearchListItemView(movie: movie) }
            )
        }
    }
    
    private var searchBar: some View {
        SearchBar(text: $searchText,
                  placeholder: NSLocalizedString("Search movies", comment: "")
        )
        .onChange(of: searchText) {
            if !$0.isEmpty {
                viewModel.send(event: .onQueryChanged($0))
            } else {
                viewModel.send(event: .onClear)
            }
        }
    }
}

struct MovieSearchListItemView: View {
    let movie: MoviesSearchViewModel.ListItem
    @Environment(\.imageCache) var cache: ImageCache

    var body: some View {
        VStack {
            title
            poster
        }
    }
    
    private var title: some View {
        Text(movie.title)
            .font(.title)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
    
    private var poster: some View {
        movie.poster.map { url in
            AsyncImage(
                url: url,
                cache: cache,
                placeholder: ActivityIndicator(isAnimating: true, style: .medium),
                configuration: { $0.resizable().renderingMode(.original) }
            )
        }
        .aspectRatio(contentMode: .fit)
        .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3)
    }
}
