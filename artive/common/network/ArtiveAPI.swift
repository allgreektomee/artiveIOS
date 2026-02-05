//
//  Config.swift
//  artive
//
//  Created by 20201385 on 2/3/26.
// API LIST

import Foundation

class ArtiveAPI {
    static let shared = ArtiveAPI()
    private init() {}
    
    static let basePath = "/api/v1"
    
    static var baseURL : String {
        let host: String
        switch AppInfoModel.shared.serverType {
            case .DEV:     host = "https://api.artivefor.me"
            case .REAL:    host = "https://api.artivefor.me"
            case .STAGING: host = "https://api.artivefor.me"
        }
        return host + basePath
    }
   
    // MARK: - User (Auth)
    static let Login = "\(baseURL)/auth/login" //로그인
    static let Logout = "\(baseURL)/auth/logout"
    static let MyProfile = "\(baseURL)/users/profile" //시용자 프로필 조회
    
    
    // MARK: - Artwork
    static let Artworks = "\(baseURL)/artworks" //
    static func artworkDetail(id: Int) -> String { "\(baseURL)/artworks/\(id)" }
    
    static func search(query: String, page: Int) -> String {
        "\(baseURL)/artworks/search?q=\(query)&page=\(page)"
    }
}
