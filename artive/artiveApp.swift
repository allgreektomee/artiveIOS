//
//  artiveApp.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import SwiftUI

@main
struct artiveApp: App {
    init() {
        //  실제 구현체를 프로토콜 타입으로 등록
        DependencyContainer.shared.register(type: APIServiceProtocol.self, component: APIService() )
        DependencyContainer.shared.register(type: ArtworkServiceProtocol.self, component: ArtworkService())
        DependencyContainer.shared.register(type: UserServiceProtocol.self, component: UserService())
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
