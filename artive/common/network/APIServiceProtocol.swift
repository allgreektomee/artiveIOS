//
//  APIServiceProtocol.swift
//  artive
//
//  Created by Park Jae Young on 2/9/26.
//

import Foundation
import Combine

//  인터페이스 정의:
protocol APIServiceProtocol {
    func get<T: Codable>(url: String, params: [String: String]) -> AnyPublisher<T, Error>
    func post<T: Codable>(url: String, body: Codable) -> AnyPublisher<T, Error>
    func put<T: Codable>(url: String, body: Codable) -> AnyPublisher<T, Error>
    func delete<T: Codable>(url: String) -> AnyPublisher<T, Error>
}

