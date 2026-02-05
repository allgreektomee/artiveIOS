//
//  User.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import Foundation


// MARK: - Request
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Response
struct LoginResponse: Codable {
    let accessToken: String
    let tokenType: String

}
struct ProfileResponse: Codable {
    let email: String
    let nickname: String
    let profileImageUrl: String?

}

