//
//  NavigationManager.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/11/26.
//

import SwiftUI
import Combine

class NavigationManager: ObservableObject {
    
    @Published var currentScreen: Route = .launch
    
    // ✅ 모든 네비게이션 히스토리가 담기는 통
    @Published var path = NavigationPath()

    /// `RealtimeSocket` 세션 축출 등 — 증가할 때마다 루트에서 강제 로그아웃 UX를 진행한다.
    @Published private(set) var sessionSupersededEpoch: UInt = 0

    func signalSessionSuperseded() {
        sessionSupersededEpoch &+= 1
    }
    
    // 화면 추가 (Push)
    func push(_ route: Route) {
        path.append(route)
    }
    
    // 뒤로 가기 (Pop)
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // 최상위로 돌아가기 (Pop to Root)
    func popToRoot() {
        path = NavigationPath()
    }
}
