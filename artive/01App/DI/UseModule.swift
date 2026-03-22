//
//  UseModule.swift
//  artive
//
//  Created by Park Jae Young on 3/19/26.
// 

import Foundation

struct UseModule {
    static func register() {
        let container = DependencyContainer.shared
        
        // 전역적으로 사용되거나, 미리 인스턴스화가 필요한 Hook들 등록
        // 예: 로그인 상태 관리, 앱 설정 등
        // container.register(type: UseAuth.self, component: UseAuth())
    }
}
