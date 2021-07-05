//
//  NetworkModel.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import Foundation

protocol NetworkModel: Decodable {
    var statusCode: Int? { get }
    var statusMessage: String? { get }
    var success: Bool? { get }
    
}
