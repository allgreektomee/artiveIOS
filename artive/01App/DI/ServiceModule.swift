//
//  ServiceModule.swift
//  artive
//
//  Created by Park Jae Young on 3/19/26.
//
// 추후 분리 가능하도록
// └─ Modules/
//    ├─ AuthModule.swift    (인증 관련 Service/Use 등록)
//    ├─ ArtworkModule.swift (작품 관련 Service/Use 등록)
//    └─ PaymentModule.swift (결제 관련 Service/Use 등록)

import Foundation

struct ServiceModule {
    static func register() {
        let container = DependencyContainer.shared
        
        // API 및 핵심 서비스 등록
        container.register(type: ServiceStorageProtocol.self, component: ServiceStorage())
        container.register(type: APIServiceProtocol.self, component: APIService())
        container.register(type: ArtworkServiceProtocol.self, component: ArtworkService())
        container.register(type: ServiceAuthProtocol.self, component: ServiceAuth())
        container.register(type: UseRealtimeSocketLog.self, component: UseRealtimeSocketLog())
        container.register(type: RealtimeSocketServiceProtocol.self, component: RealtimeSocketService())

        // (확장) 추후 WebBridgeService 등도 여기서 등록
        // container.register(type: WebBridgeServiceProtocol.self, component: WebBridgeService())
    }
}
