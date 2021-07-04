//
//  MovieListViewModel.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import Foundation
import Combine

final class MoviesSearchViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }

}

// MARK: - Inner Types

extension MoviesSearchViewModel {
    enum State {
        case idle
        case loading(String)
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onQueryChanged(String)
        case onClear
        case onSelectMovie(Int)
        case onMoviesLoaded([ListItem])
        case onFailedToLoadMovies(Error)
    }
    
    struct ListItem: Identifiable {
        let id: Int
        let title: String
        let poster: URL?
        
        init(movie: MovieDTO) {
            id = movie.id
            title = movie.title
            poster = movie.poster
        }
    }
    
}

// MARK: - State Machine

extension MoviesSearchViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle, .loaded:
            switch event {
            case .onQueryChanged(let query):
                return .loading(query)
            case .onClear:
                return .idle
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadMovies(let error):
                return .error(error)
            case .onMoviesLoaded(let movies):
                return .loaded(movies)
            default:
                return state
            }
        case .error:
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let query) = state else { return Empty().eraseToAnyPublisher() }
            
            return MoviesAPI.searchMovies(with: MovieSearchRequestDTO(query: query, page: 1))
                .map { $0.movies.map(ListItem.init) }
                .map(Event.onMoviesLoaded)
                .catch { Just(Event.onFailedToLoadMovies($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
