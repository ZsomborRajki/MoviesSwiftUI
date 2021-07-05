//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 06. 19..
//

import Foundation
import Combine

struct Agent {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, NetworkError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap {
                if let response = $1 as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                return $0
            }
            .handleEvents(receiveOutput: {
                print("==== Response ====")
                print(String(decoding: $0, as: UTF8.self))
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .mapError { handleError($0) }
            .eraseToAnyPublisher()
    }
}

private extension Agent {
    
    func httpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 402, 405...499:
            return .error4xx(statusCode)
        case 500:
            return .serverError
        case 501...599:
            return .error5xx(statusCode)
        default:
            return .unknownError
        }
    }
    
    func handleError(_ error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError where urlError.code == .notConnectedToInternet:
            return .notConnected
        case let urlError as URLError where urlError.code == .cancelled:
            return .cancelled
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkError:
            return error
        default:
            return .unknownError
        }
    }
}
