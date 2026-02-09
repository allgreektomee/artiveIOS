//
//  Config.swift
//  artive
//
//  Created by 20201385 on 2/3/26.
// API LIST

import Foundation

enum ArtiveAPI {
    case login
    case logout
    case artworks
    case artworkDetail(id: Int)
    
    static var baseURL: String {
        let host: String
        // 관리자님의 AppInfoModel 환경 설정 참조
        switch AppInfoModel.shared.serverType {
        case .DEV:     host = "https://api.artivefor.me"
        case .REAL:    host = "https://api.artivefor.me"
        case .STAGING: host = "https://api.artivefor.me"
        }
        return host + "/api/v1"
    }
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .logout: return "/auth/logout"
        case .artworks: return "/artworks"
        case .artworkDetail(let id): return "/artworks/\(id)"
        }
    }
    
    var url: String {
        return ArtiveAPI.baseURL + self.path
    }
}
