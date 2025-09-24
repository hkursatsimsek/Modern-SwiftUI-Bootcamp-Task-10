//
//  HTTPError.swift
//  Modern-SwiftUI-Bootcamp-Task-10
//
//  Created by Kürşat Şimşek on 24.09.2025.
//


import Foundation

public enum HTTPError: LocalizedError, Equatable {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case statusCode(Int)
    case decoding(Error)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .transport(let error):
            return "Ağ hatası: \(error.localizedDescription)"
        case .invalidResponse:
            return "Geçersiz yanıt"
        case .statusCode(let code):
            return "Sunucu hatası (\(code))"
        case .decoding:
            return "Veri çözümlenemedi"
        case .unknown:
            return "Bilinmeyen hata"
        }
    }

    public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.unknown, .unknown):
            return true
        case let (.statusCode(a), .statusCode(b)):
            return a == b
        case let (.transport(e1), .transport(e2)):
            let n1 = e1 as NSError
            let n2 = e2 as NSError
            return n1.domain == n2.domain && n1.code == n2.code
        case let (.decoding(e1), .decoding(e2)):
            let n1 = e1 as NSError
            let n2 = e2 as NSError
            return n1.domain == n2.domain && n1.code == n2.code
        default:
            return false
        }
    }
}
