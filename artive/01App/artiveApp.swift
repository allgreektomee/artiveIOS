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
        // 의존성 등록 책임을 AppContainer에 위임합니다.
        AppContainer.shared.registerDependencies()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
