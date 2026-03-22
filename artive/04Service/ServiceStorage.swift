//
//  ServiceStorage.swift
//  artive
//
//  Created by Park Jae Young on 3/19/26.
//

import Foundation

// MARK: - Interface
protocol ServiceStorageProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func clearAll()
}

// MARK: - Implementation
class ServiceStorage: BaseService, ServiceStorageProtocol {
    

    
    // 싱글톤 제거! (주입은 DIContainer에서 담당)
    private let keychain = KeychainHelper.standard
    
    private let serviceId = "com.artive.auth"

    func saveToken(_ token: String) {
        if let data = token.data(using: .utf8) {
            keychain.save(data, service: serviceId, account: "accessToken")
            DLog("Token Saved")
        }
    }
    
    func getToken() -> String? {
        if let data = keychain.read(service: serviceId, account: "accessToken") {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func clearAll() {
        keychain.delete(service: serviceId, account: "accessToken")
        DLog("Storage Cleared")
    }
}
