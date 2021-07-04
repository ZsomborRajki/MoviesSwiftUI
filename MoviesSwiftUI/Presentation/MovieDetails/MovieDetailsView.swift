//
//  MovieDetailsView.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Environment(\.imageCache) var cache: ImageCache
    
    var body: some View {
        content
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
        case .loaded(let movie):
            return self.movie(movie).eraseToAnyView()
        }
    }
    
    private func movie(_ movie: MovieDetailViewModel.MovieDetail) -> some View {
        ScrollView {
            VStack {
                fillWidth
                
                Text(movie.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                             
                Divider()

                HStack(alignment: .center) {
                    Text(movie.releasedAt)
                    Text(movie.language)
                    Text(movie.duration)
                }
                .font(.subheadline)
                .padding()
                
                poster(of: movie)
                                
                genres(of: movie)
                
                Divider()

                movie.rating.map {
                    Text("⭐️ \(String($0))/10")
                        .font(.body)
                }
                
                Divider()

                movie.overview.map {
                    Text($0)
                        .font(.body)
                }
            }
        }
    }
    
    private var fillWidth: some View {
        HStack {
            Spacer()
        }
    }
    
    private func poster(of movie: MovieDetailViewModel.MovieDetail) -> some View {
        movie.poster.map { url in
            AsyncImage(
                url: url,
                cache: cache,
                placeholder: ActivityIndicator(isAnimating: true, style: .large),
                configuration: { $0.resizable() }
            )
            .aspectRatio(contentMode: .fit)
        }
    }
    
    private func genres(of movie: MovieDetailViewModel.MovieDetail) -> some View {
        HStack {
            ForEach(movie.genres, id: \.self) { genre in
                Text(genre)
                    .padding(5)
                    .border(Color.gray)
            }
        }
    }
    
}
