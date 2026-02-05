//
//  AuthManager.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import Foundation
import Combine


class AuthManager: ObservableObject{
    static let shared = AuthManager()
    
    @Published var isAuthenticated: Bool
    
    private let service = "com.artive.auth"
    private let account = "accessToken"
    
    private init() {
        let data = KeychainHelper.standard.read(service: "com.artive.auth", account: "accessToken")
        self.isAuthenticated = data != nil
    }
    
    private let tokenKey = "access_token"
    
    func saveToken(_ token: String) {
        if let data = token.data(using: .utf8) {
            KeychainHelper.standard.save(data, service: service, account: account)
            DispatchQueue.main.async {
                self.isAuthenticated = true
            }
        }
    }
    
    func getToken() -> String? {
        if let data = KeychainHelper.standard.read(service: service, account: account) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func clearToken() {
        KeychainHelper.standard.delete(service: service, account: account)
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
}

