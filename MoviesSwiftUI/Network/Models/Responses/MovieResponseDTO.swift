//
//  MovieSearchResponseDTO.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//


import Foundation

// MARK: - Data Transfer Object

struct MovieResponseDTO: Decodable, Hashable, NetworkModel {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
        case success
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
    
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
    
    var statusCode: Int?
    var statusMessage: String?
    var success: Bool?
    
}

struct MovieDTO: Decodable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
    let id: Int
    let title: String
    let posterPath: String?
    var poster: URL? { posterPath.map { MoviesAPI.imageBase.appendingPathComponent($0) } }
}
