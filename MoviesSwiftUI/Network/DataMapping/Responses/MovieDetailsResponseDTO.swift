//
//  MovieDetailsResponseDTO+Mapping.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import Foundation

// MARK: - Data Transfer Object

struct MovieDetailsResponseDTO: Decodable, Hashable, NetworkModel {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case genres
        case releaseDate = "release_date"
        case runtime
        case spokenLanguages = "spoken_languages"
        case success
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
    
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let voteAverage: Double?
    let genres: [GenreDTO]
    let releaseDate: String?
    let runtime: Int?
    let spokenLanguages: [LanguageDTO]
    
    var poster: URL? { posterPath.map { MoviesAPI.imageBase.appendingPathComponent($0) } }
    
    struct GenreDTO: Decodable, Hashable {
        let id: Int
        let name: String
    }
    
    struct LanguageDTO: Decodable, Hashable {
        private enum CodingKeys: String, CodingKey {
            case name
            case englishName = "english_name"
            case languageCode = "iso_639_1"
        }
        let name: String
        let englishName: String
        let languageCode: String
    }
    
    var statusCode: Int?
    var statusMessage: String?
    var success: Bool?
}

