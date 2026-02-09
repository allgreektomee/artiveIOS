//
//  DependencyContainer.swift
//  artive
//
//  Created by Park Jae Young on 2/9/26.
//

import Foundation

final class DependencyContainer {
    // 💡 싱글톤 인스턴스
    static let shared = DependencyContainer()
    
    // 💡 서비스들을 담아둘 딕셔너리
    private var services: [String: Any] = [:]
    
    private init() {}
    
    // 💡 서비스 등록 (App 시작 시 호출)
    func register<T>(type: T.Type, component: T) {
        let key = String(describing: type)
        services[key] = component
    }
    
    // 💡 서비스 추출 (@Inject에서 호출)
    func resolve<T>(type: T.Type) -> T {
        let key = String(describing: type)
        guard let service = services[key] as? T else {
            // 등록되지 않은 서비스를 호출하면 앱을 멈춰서 개발자에게 알려줌
            fatalError("❌ [DI Error] \(key)가 등록되지 않았습니다. App 메인에서 register를 확인하세요.")
        }
        return service
    }
}
