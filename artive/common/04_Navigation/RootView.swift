//
//  RootView.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/11/26.
//
import SwiftUI

struct RootView: View {
    @StateObject private var navManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navManager.path) {
            // ✅ currentScreen 상태 변경 감지 및 화면 교체
            Group {
                switch navManager.currentScreen {
                case .launch:
//                    AppLauncherView()
                case .login:
                    
                    LoginView()
                case .main:
                    // TODO: 실제 메인 뷰로 교체
                    Text("메인 화면")
                        .font(.largeTitle)
                case .webView(url: let url):
                    Text("webView")
                        .font(.largeTitle)
                }
            }
            // ✅ 네비게이션 스택(Push) 이동 경로 처리
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .launch:
//                    AppLauncherView()
                case .login:
                    // TODO: 실제 로그인 뷰로 교체
                    Text("로그인 화면")
                        .font(.largeTitle)
                case .main:
                    // TODO: 실제 메인 뷰로 교체
                    Text("메인 화면")
                        .font(.largeTitle)
                case .webView(url: let url):
                    Text("webView")
                        .font(.largeTitle)
                }
            }
        }
        .environmentObject(navManager) // 하위 뷰에서 접근 가능하도록 주입
    }
}
