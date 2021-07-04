//
//  MovieListView.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import Combine
import SwiftUI

struct MoviesTrendingView: View {
    @ObservedObject var viewModel: MoviesTrendingViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationBarTitle("Trending Movies")
        }
        .onAppear { self.viewModel.send(event: .onAppear) }
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
            return list(of: movies).eraseToAnyView()
        }
    }
    
    private func list(of movies: [MoviesTrendingViewModel.ListItem]) -> some View {
        return List(movies) { movie in
            NavigationLink(
                destination: MovieDetailView(viewModel: MovieDetailViewModel(movieID: movie.id)),
                label: { MovieListItemView(movie: movie) }
            )
        }
    }
}

struct MovieListItemView: View {
    let movie: MoviesTrendingViewModel.ListItem
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
                placeholder: spinner,
                configuration: { $0.resizable().renderingMode(.original) }
            )
        }
        .aspectRatio(contentMode: .fit)
        .frame(idealHeight: UIScreen.main.bounds.width / 2 * 3)
    }
    
    private var spinner: some View {
        ActivityIndicator(isAnimating: true, style: .medium)
    }
}
