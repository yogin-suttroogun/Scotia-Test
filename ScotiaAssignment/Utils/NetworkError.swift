//
//  NetworkError.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-24.
//

import Foundation

enum NetworkError: LocalizedError {
    case fileNotFound(name: String)
    case decodingFailed(error: Error)
    case dataLoadFailed(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "Json file with name \(name) not found"
        case .decodingFailed(let error):
            return "Failed to decode json: \(error.localizedDescription)"
        case .dataLoadFailed(let error):
            return "Failed to load data: \(error.localizedDescription)"
        }
    }
}
