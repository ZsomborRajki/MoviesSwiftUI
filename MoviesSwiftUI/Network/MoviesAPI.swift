//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 06. 19..
//

import Foundation
import Combine
import CryptoKit

enum MoviesAPI {
    static let imageBase = URL(string: "https://image.tmdb.org/t/p/original/")!
    
    private static let baseUrlV3 = "https://api.themoviedb.org/3"
    private static let baseUrlV4 = "https://api.themoviedb.org/4"
   
    private static let agent = Agent()
    private static let token = Secrets.apiReadAccessToken.value
    
    static func searchMovies(with movieSearchRequestDTO: MovieSearchRequestDTO) -> AnyPublisher<MovieResponseDTO, NetworkError> {
        guard let baseUrl = URL(string: baseUrlV4) else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }
        
        let request = URLComponents(url: baseUrl.appendingPathComponent("search/movie"), resolvingAgainstBaseURL: true)?
            .addPage(movieSearchRequestDTO.page)
            .addSearchQuery(movieSearchRequestDTO.query)
            .request
        
        guard let request = request else {
            return Fail(error: .invalidRequest).eraseToAnyPublisher()
        }
        
        return agent.run(request.addAuthToken(token))
    }
    
    static func trendinghMovies() -> AnyPublisher<MovieResponseDTO, NetworkError> {
        guard let baseUrl = URL(string: baseUrlV3) else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }
        
        let request = URLComponents(url: baseUrl.appendingPathComponent("trending/movie/week"), resolvingAgainstBaseURL: true)?
            .request
        
        guard let request = request else {
            return Fail(error: .invalidRequest).eraseToAnyPublisher()
        }
        
        return agent.run(request.addAuthToken(token))
    }
    
    static func movieDetails(with movieDetailsRequestDTO: MovieDetailsRequestDTO) -> AnyPublisher<MovieDetailsResponseDTO, NetworkError> {
        guard let baseUrl = URL(string: baseUrlV3) else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }
        
        let request = URLComponents(url: baseUrl.appendingPathComponent("movie/\(movieDetailsRequestDTO.id)"), resolvingAgainstBaseURL: true)?
            .request
    
        guard let request = request else {
            return Fail(error: .invalidRequest).eraseToAnyPublisher()
        }
        
        return agent.run(request.addAuthToken(token))
    }
}

private extension URLComponents {
    
    func addPage(_ pageNumber: Int) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: "page", value: "\(pageNumber)")]
        return copy
    }
    
    func addSearchQuery(_ query: String) -> URLComponents {
        var copy = self
        copy.queryItems = [URLQueryItem(name: "query", value: query)]
        return copy
    }
    
    var request: URLRequest? {
        url.map { URLRequest(url: $0) }
    }
}

private extension URLRequest {
    
    func addAuthToken(_ token: String) -> URLRequest {
        var copy = self
        copy.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return copy
    }
}
