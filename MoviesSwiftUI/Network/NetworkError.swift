//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 06. 19..
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidUrl
    case notConnected
    case cancelled
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
}
 
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return NSLocalizedString("Decoding error", comment: "")
        case .notConnected:
            return NSLocalizedString("Internet connection is required", comment: "")
        default:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
