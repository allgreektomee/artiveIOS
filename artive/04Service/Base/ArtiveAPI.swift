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

    /// REST 베이스 (`https://host/api/v1` 등)
    private static var apiOrigin: String {
        switch AppInfoModel.shared.serverType {
        case .DEV, .REAL, .STAGING:
            return "https://api.artivefor.me"
        }
    }

    static var baseURL: String {
        apiOrigin + "/api/v1"
    }

    /// Spring `WebSocketConfig`: `/ws/realtime?token=<JWT>`
    static func realtimeWebSocketURL(accessToken: String) -> URL? {
        let wsRoot = apiOrigin.replacingOccurrences(of: "https://", with: "wss://")
        var c = URLComponents(string: wsRoot + "/ws/realtime")
        c?.queryItems = [URLQueryItem(name: "token", value: accessToken)]
        return c?.url
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
