//
//  AppContainer.swift
//  artive
//
//  Created by Park Jae Young on 3/19/26.
//

import Foundation

class AppContainer {
    static let shared = AppContainer()
    private init() {}
    
    func registerDependencies() {
        // 모든 의존성 등록은 여기서만 책임진다.
        // MARK: - [04 Service]
        ServiceModule.register()
        
        // MARK: - [05 Use]
        UseModule.register()
    }
}
